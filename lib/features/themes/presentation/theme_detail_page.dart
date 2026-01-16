import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// (실제) 테마에 속한 종목 모델
class ThemeStockItem {
  final String name;
  final String code;
  final int price; // 현재가
  final int change; // 등락금액 (+/-)
  final double changeRate; // 등락률 (+/-)

  const ThemeStockItem({
    required this.name,
    required this.code,
    required this.price,
    required this.change,
    required this.changeRate,
  });
}

enum SortType { price, changeRate }

/// 정렬 책임 분리
extension ThemeStockSorting on List<ThemeStockItem> {
  List<ThemeStockItem> sortedBy(SortType type) {
    final copied = [...this];
    copied.sort((a, b) {
      if (type == SortType.price) return b.price.compareTo(a.price); // 가격 높은 순
      return b.changeRate.compareTo(a.changeRate); // 등락률 높은 순
    });
    return copied;
  }
}

/// 특정 테마에 속한 종목 목록을 보여주는 페이지
class ThemeDetailPage extends StatefulWidget {
  final String themeName;
  final List<ThemeStockItem> items;

  const ThemeDetailPage({
    super.key,
    required this.themeName,
    required this.items,
  });

  /// 개발/미리보기용
  factory ThemeDetailPage.preview({Key? key, required String themeName}) {
    // Mock Data
    const dummy = [
      ThemeStockItem(name: '삼성전자', code: '005930', price: 71000, change: 1200, changeRate: 1.72),
      ThemeStockItem(name: 'LG에너지솔루션', code: '373220', price: 392000, change: -4500, changeRate: -1.14),
      ThemeStockItem(name: '포스코퓨처엠', code: '003670', price: 311500, change: 8500, changeRate: 2.81),
      ThemeStockItem(name: '에코프로비엠', code: '247540', price: 210000, change: -3200, changeRate: -1.50),
      ThemeStockItem(name: '삼성SDI', code: '006400', price: 373000, change: 2000, changeRate: 0.54),
      ThemeStockItem(name: '엘앤에프', code: '066970', price: 119000, change: -900, changeRate: -0.75),
      ThemeStockItem(name: 'SK하이닉스', code: '000660', price: 132000, change: 3000, changeRate: 2.32),
      ThemeStockItem(name: 'NAVER', code: '035420', price: 210500, change: -1500, changeRate: -0.71),
    ];
    return ThemeDetailPage(key: key, themeName: themeName, items: dummy);
  }

  @override
  State<ThemeDetailPage> createState() => _ThemeDetailPageState();
}

class _ThemeDetailPageState extends State<ThemeDetailPage> {
  SortType _sortType = SortType.price;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sortedItems = widget.items.sortedBy(_sortType);

    // Mock Summary Data
    final double avgChangeRate = 1.25;
    final int upCount = widget.items.where((e) => e.changeRate > 0).length;
    final int downCount = widget.items.where((e) => e.changeRate < 0).length;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.themeName),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, size: 28),
            onPressed: () => context.push('/search'),
          ),
        ],
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // 1. Theme Summary (Non-Sliver wrapper) or SliverToBoxAdapter
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

          // 2. Sort Toggle & Total Count
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   _SortSegmentControl(
                    sortType: _sortType,
                    onChanged: (val) => setState(() => _sortType = val),
                  ),
                  Text(
                    '총 ${widget.items.length}개',
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
                  final item = sortedItems[index];
                  return _StockListTile(
                    rank: index + 1,
                    item: item,
                    onTap: () {
                         // TODO: Detail Page
                     },
                  );
                },
                childCount: sortedItems.length,
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
            color: Colors.black.withOpacity(0.04), // Reduced shadow to emphasize border
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
                  // "Strong/Weak" Badge Removed
                  Text(
                    '${isUp ? '+' : ''}${avgChangeRate.toStringAsFixed(2)}%',
                    style: TextStyle(
                      fontSize: 32, // Slightly larger
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
  final SortType sortType;
  final ValueChanged<SortType> onChanged;

  const _SortSegmentControl({required this.sortType, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSegment('주가순', SortType.price),
          _buildSegment('등락률순', SortType.changeRate),
        ],
      ),
    );
  }

  Widget _buildSegment(String text, SortType type) {
    final isSelected = sortType == type;
    return GestureDetector(
      onTap: () => onChanged(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
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
    final isUp = item.change >= 0;
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
                    item.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.code,
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
                  '${_formatInt(item.price)}원',
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
