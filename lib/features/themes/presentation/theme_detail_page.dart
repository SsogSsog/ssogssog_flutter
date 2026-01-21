import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ssogssog_flutter/features/themes/data/model/theme_models.dart';
import 'package:ssogssog_flutter/features/themes/data/repository/theme_repository.dart';

/// 특정 테마에 속한 종목 목록을 보여주는 페이지
class ThemeDetailPage extends StatefulWidget {
  final String themeName;
  final ThemeItem? themeItem; // List Page에서 넘어온 기본 정보 (평균 등락률용)

  const ThemeDetailPage({
    super.key,
    required this.themeName,
    this.themeItem,
  });

  /// 개발/미리보기용 (더 이상 사용 안함, 하위 호환 위해 남겨둠 or 삭제)
  factory ThemeDetailPage.preview({Key? key, required String themeName}) {
    return ThemeDetailPage(key: key, themeName: themeName);
  }

  @override
  State<ThemeDetailPage> createState() => _ThemeDetailPageState();
}

class _ThemeDetailPageState extends State<ThemeDetailPage> {
  final ThemeRepository _repository = ThemeRepository();
  final ScrollController _scrollController = ScrollController();

  // Data State
  ThemeCountResult? _countResult;
  List<ThemeStockItem> _items = [];

  // Paging State
  bool _isLoading = false;
  int _page = 0;
  bool _hasNext = true;
  static const int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    _fetchCounts();
    _fetchNextPage();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _fetchNextPage();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchCounts() async {
    final result = await _repository.getThemeDetailCounts(widget.themeName);
    if (mounted && result != null) {
      setState(() {
        _countResult = result;
      });
    }
  }

  Future<void> _fetchNextPage() async {
    if (_isLoading || !_hasNext) return;

    setState(() {
      _isLoading = true;
    });

    final result = await _repository.getThemeStockList(
      widget.themeName,
      _page,
      _pageSize,
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (result != null) {
          _items.addAll(result.content);
          _hasNext = result.hasNext;
          if (_hasNext) {
            _page++;
          }
        } else {
          _hasNext = false; // Stop on error
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Use passed themeItem for average rate, or 0.0 if missing
    final avgChangeRate = widget.themeItem?.changeRateAverage ?? 0.0;
    
    // Counts from API 1
    final upCount = _countResult?.risingCount ?? 0;
    final downCount = _countResult?.fallingCount ?? 0;
    final totalCount = _countResult?.totalCount ?? 0;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.themeName),
        centerTitle: false,
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // 1. Theme Summary (Avg Return + Rising/Falling)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _ThemeSummaryCard(
                avgChangeRate: avgChangeRate,
                upCount: upCount,
                downCount: downCount,
              ),
            ),
          ),

          // 2. Sort Toggle & Total Count (Visual Only for now as sort is fixed)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   // Placeholder for Sort Control (Disabled/Fixed as per instructions)
                   const _SortSegmentControl(),
                  Text(
                    '총 $totalCount개',
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.hintColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Stock List
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index < _items.length) {
                    final item = _items[index];
                    return _StockListTile(
                      rank: index + 1,
                      item: item,
                      onTap: () {
                        context.push('/stock/${item.stockCode}');
                      },
                    );
                  } else {
                     return _isLoading 
                        ? const Center(child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ))
                        : const SizedBox.shrink();
                  }
                },
                childCount: _items.length + (_hasNext ? 1 : 0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeSummaryCard extends StatelessWidget {
  final double avgChangeRate;
  final int upCount;
  final int downCount;

  const _ThemeSummaryCard({
    required this.avgChangeRate,
    required this.upCount,
    required this.downCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUp = avgChangeRate >= 0;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.12),
          width: 1.5, 
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('평균 수익률', 
                    style: TextStyle(
                      fontSize: 14, 
                      color: theme.hintColor.withOpacity(0.8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${isUp ? '+' : ''}${avgChangeRate.toStringAsFixed(2)}%',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: isUp ? const Color(0xFFE5484D) : const Color(0xFF2F6FED),
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 1,
            color: theme.dividerColor.withOpacity(0.1),
          ),
          const SizedBox(height: 16),
          // Advancing / Declining
          Row(
            children: [
              Expanded(
                child: _buildCountStat(theme, '상승', upCount, const Color(0xFFE5484D), Icons.arrow_upward_rounded),
              ),
              Container(
                width: 1, height: 24,
                color: theme.dividerColor.withOpacity(0.2),
              ),
              Expanded(
                child: _buildCountStat(theme, '하락', downCount, const Color(0xFF2F6FED), Icons.arrow_downward_rounded),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCountStat(ThemeData theme, String label, int count, Color color, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(
          '$count종목 $label',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}

class _SortSegmentControl extends StatelessWidget {
  const _SortSegmentControl();

  @override
  Widget build(BuildContext context) {
    // Fixed visual only as per user instructions
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSegment('주가순', true),
          _buildSegment('등락률순', false),
        ],
      ),
    );
  }

  Widget _buildSegment(String text, bool isSelected) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected 
            ? [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2))]
            : [],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.black : Colors.grey.shade600,
          ),
        ),
      );
  }
}


class _StockListTile extends StatelessWidget {
  final int rank;
  final ThemeStockItem item;
  final VoidCallback onTap;

  const _StockListTile({
    required this.rank,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUp = item.changeRate >= 0;
    final rateColor = isUp ? const Color(0xFFE5484D) : const Color(0xFF2F6FED);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: theme.dividerColor.withOpacity(0.08),
            ),
          ),
        ),
        child: Row(
          children: [
            // Rank
            SizedBox(
              width: 24,
              child: Text(
                rank.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: theme.hintColor.withOpacity(0.4),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.corpName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.stockCode,
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.hintColor.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            // Price & Rate
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${_formatInt(item.closePrice)}원',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${isUp ? '+' : ''}${item.changeRate.toStringAsFixed(2)}%',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: rateColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatInt(int n) {
    final neg = n < 0;
    final s = n.abs().toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
        final posFromEnd = s.length - i;
        buf.write(s[i]);
        if (posFromEnd > 1 && posFromEnd % 3 == 1) buf.write(',');
    }
    return neg ? '-${buf.toString()}' : buf.toString();
  }
}
