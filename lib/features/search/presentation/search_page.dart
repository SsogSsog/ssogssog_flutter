import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ssogssog_flutter/features/search/data/model/search_models.dart';
import 'package:ssogssog_flutter/features/search/data/repository/search_repository.dart';
import 'package:ssogssog_flutter/features/search/presentation/widget/search_result_list.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchRepository _repository = SearchRepository();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  
  String _query = '';
  Timer? _debounce;

  // Autocomplete State
  List<SearchStockItem> _autocompleteResults = [];

  // Full Search State
  bool _showFullResults = false; // true if Enter pressed
  List<SearchStockItem> _searchResults = [];
  bool _isLoading = false;
  int _page = 0;
  bool _hasNext = true;
  static const int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    // 화면 진입 시 자동으로 키보드 올리기
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });

    _scrollController.addListener(() {
      if (_showFullResults && 
          _scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        _fetchNextPage();
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    setState(() {
      _query = query;
      // If user is typing, we switch back to autocomplete mode immediately
      if (_showFullResults) {
        _showFullResults = false;
        _searchResults.clear();
      }
    });

    if (query.isEmpty) {
      setState(() {
        _autocompleteResults = [];
      });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _fetchAutocomplete(query);
    });
  }

  Future<void> _fetchAutocomplete(String query) async {
    final results = await _repository.getAutocomplete(query);
    if (mounted) {
      setState(() {
        _autocompleteResults = results;
      });
    }
  }

  void _onSubmitted(String query) {
    if (query.isEmpty) return;
    
    _debounce?.cancel();
    setState(() {
      _showFullResults = true;
      _page = 0;
      _itemsClear();
      _hasNext = true; // Reset hasNext for new search
    });
    _fetchNextPage();
  }

  void _itemsClear() {
    _searchResults.clear();
  }

  Future<void> _fetchNextPage() async {
    if (_isLoading || !_hasNext) return;

    setState(() {
      _isLoading = true;
    });

    final result = await _repository.searchStocks(_query, _page, _pageSize);

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (result != null) {
          _searchResults.addAll(result.content);
          _hasNext = result.hasNext;
          if (_hasNext) {
            _page++;
          }
        } else {
          _hasNext = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: TextField(
            controller: _searchController,
            focusNode: _focusNode,
            onChanged: _onSearchChanged,
            onSubmitted: _onSubmitted,
            textInputAction: TextInputAction.search,
            style: const TextStyle(fontSize: 16),
            decoration: InputDecoration(
              hintText: '종목명, 지수, 코인 검색',
              hintStyle: TextStyle(
                color: theme.hintColor.withOpacity(0.5),
                fontSize: 16,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              suffixIcon: _query.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.cancel, color: theme.hintColor, size: 20),
                      onPressed: () {
                        _searchController.clear();
                        _onSearchChanged('');
                      },
                    )
                  : null,
            ),
          ),
        ),
      ),
      body: _buildBody(theme),
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (_query.isEmpty) {
      return _buildEmptyState(theme);
    }

    if (_showFullResults) {
      // Full Search Results (Pagination)
      return SearchResultList(
        results: _searchResults, 
        query: _query,
        scrollController: _scrollController,
        isLoading: _isLoading,
      );
    } else {
      // Autocomplete Suggestions (No Pagination)
      return SearchResultList(
        results: _autocompleteResults,
        query: _query,
        isLoading: false, // Autocomplete doesn't show bottom loader
      );
    }
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Text(
        '궁금한 종목을 검색해보세요',
        style: TextStyle(
          color: theme.hintColor.withOpacity(0.5),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
