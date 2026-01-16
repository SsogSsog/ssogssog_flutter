import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ssogssog_flutter/features/search/presentation/widget/search_result_list.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _query = '';

  // Mock Data for Search
  final List<String> _allStocks = [
    '삼성전자',
    '삼성화재',
    '삼성바이오로직스',
    '삼성물산',
    '삼성SDI',
    'SK하이닉스',
    'LG에너지솔루션',
    '현대차',
    '기아',
    'POSCO홀딩스',
    'NAVER',
    '카카오',
    '셀트리온',
  ];

  List<String> _searchResults = [];

  @override
  void initState() {
    super.initState();
    // 화면 진입 시 자동으로 키보드 올리기
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _query = query;
      if (query.isEmpty) {
        _searchResults = [];
      } else {
        _searchResults = _allStocks
            .where((stock) => stock.contains(query))
            .toList();
      }
    });
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
      body: _query.isEmpty
          ? _buildEmptyState(theme)
          : SearchResultList(results: _searchResults, query: _query),
    );
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
