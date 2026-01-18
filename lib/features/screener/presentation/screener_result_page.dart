import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ssogssog_flutter/core/theme/app_theme.dart';
import 'package:ssogssog_flutter/features/screener/data/model/screener_models.dart';
import 'package:ssogssog_flutter/features/screener/data/repository/screener_repository.dart';
import 'package:ssogssog_flutter/features/screener/presentation/widget/applied_filter_bottom_sheet.dart';
import 'package:ssogssog_flutter/features/screener/presentation/widget/screener_result_card.dart';

class ScreenerResultPage extends StatefulWidget {
  final ScreenerRequest? request; // Request from arguments

  const ScreenerResultPage({super.key, this.request});

  @override
  State<ScreenerResultPage> createState() => _ScreenerResultPageState();
}

class _ScreenerResultPageState extends State<ScreenerResultPage> {
  final ScreenerRepository _repository = ScreenerRepository();
  final ScrollController _scrollController = ScrollController();

  // --- State ---
  List<ScreenerItem> _items = [];
  bool _isLoading = false;
  bool _hasNext = true;
  int _nextPage = 0;
  int _totalCount = 0; // Total count might not be in Slice, but we can try to infer or just show count of loaded items (Slice usually doesn't give total count)

  // API spec: SliceDTO result (content, size, hasNext, currentPage)
  // Note: Slice typically does NOT return total elements. We might need to hide "Total X found" or update backend to return Page.
  // For now, let's just show "Searching..." or loaded count.
  
  @override
  void initState() {
    super.initState();
    // 1. Initial Load
    _fetchNextPage();

    // 2. Infinite Scroll Listener
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        if (!_isLoading && _hasNext) {
          _fetchNextPage();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchNextPage() async {
    if (widget.request == null) return;

    setState(() => _isLoading = true);

    final result = await _repository.getScreenerResults(
      request: widget.request!,
      page: _nextPage,
      size: 10,
    );

    if (mounted) {
      if (result != null) {
        setState(() {
          _items.addAll(result.content);
          _hasNext = result.hasNext;
          if (_hasNext) {
            _nextPage++;
          }
          // If backend doesn't give total count, we can only show loaded count so far or hide it.
          _totalCount = _items.length; 
        });
      }
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('검색 결과'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.pop(),
        ),
      ),
      backgroundColor: const Color(0xFFF6F7FB),
      body: Column(
        children: [
          _buildCurrentFilterHeader(context),
          Expanded(
            child: _items.isEmpty && !_isLoading
                ? const Center(child: Text('검색 결과가 없습니다.'))
                : ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    itemCount: _items.length + (_isLoading ? 1 : 0),
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, index) {
                      if (index == _items.length) {
                        return const Center(child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator.adaptive(),
                        ));
                      }
                      
                      final item = _items[index];
                      return ScreenerResultCard(
                        name: item.corpName,
                        code: item.stockCode,
                        price: item.currentPrice,
                        // Change Rate is not explicitly detailed in ScreenerItem DTO I updated earlier?
                        // Wait, user provided spec: "stockId, ..., currentPrice, return3M..."
                        // Ah, "changeRate" (daily change) might not be in the ScreenerItem JSON provided by user?
                        // "salesGrowthYoY..." etc.
                        // Let me check user's JSON spec again carefully.
                        // "currentPrice": 0, "marketCap": 0... "return3M"...
                        // It seems "Daily Change Rate" is missing from the provided ScreenerItem JSON fields.
                        // I will use 0.0 or calculate it if possible (can't calc without prev close).
                        // I'll show return3M or similar, OR just assume 0 for now and ask user later.
                        // Actually, reusing UI usually expects daily change.
                        // Let's pass 0.0 for changeRate for now to resolve compile errors, 
                        // and maybe user means 'return3M' is what they want to see, or daily change is missing.
                        changeRate: 0.0, 
                        volume: 0, // Volume also missing in JSON? Yes.
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentFilterHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (_) => AppliedFilterBottomSheet(request: widget.request),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFEDEFF5)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.tune_rounded, size: 18, color: AppColors.primaryBlue),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        '현재 필터 보기',
                        style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800),
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: Color(0xFF8B93A1)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Slice doesn't give total count. Use loaded count.
          Text(
            '$_totalCount건이 검색되었습니다 (더보기...)', 
            style: const TextStyle(color: Color(0xFF8B93A1), fontSize: 12.5, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
