import 'package:flutter/material.dart';

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

// 나중에 서버 연동 시 여기만 추가하면 됨 (UI 영향 없음)
// factory ThemeStockItem.fromJson(Map<String, dynamic> json) {
//   return ThemeStockItem(
//     name: json['name'] as String,
//     code: json['code'] as String,
//     price: json['price'] as int,
//     change: json['change'] as int,
//     changeRate: (json['changeRate'] as num).toDouble(),
//   );
// }
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

  /// 서버에서 받은 리스트를 그대로 주입
  final List<ThemeStockItem> items;

  const ThemeDetailPage({
    super.key,
    required this.themeName,
    required this.items,
  });

  /// 개발/미리보기용
  factory ThemeDetailPage.preview({Key? key, required String themeName}) {
    const dummy = [
      ThemeStockItem(name: '삼성전자', code: '005930', price: 71000, change: 1200, changeRate: 1.72),
      ThemeStockItem(name: 'LG에너지솔루션', code: '373220', price: 392000, change: -4500, changeRate: -1.14),
      ThemeStockItem(name: '포스코퓨처엠', code: '003670', price: 311500, change: 8500, changeRate: 2.81),
      ThemeStockItem(name: '에코프로비엠', code: '247540', price: 210000, change: -3200, changeRate: -1.50),
      ThemeStockItem(name: '삼성SDI', code: '006400', price: 373000, change: 2000, changeRate: 0.54),
      ThemeStockItem(name: '엘앤에프', code: '066970', price: 119000, change: -900, changeRate: -0.75),
    ];
    return ThemeDetailPage(key: key, themeName: themeName, items: dummy);
  }

  @override
  State<ThemeDetailPage> createState() => _ThemeDetailPageState();
}

class _ThemeDetailPageState extends State<ThemeDetailPage> {
  SortType _sortType = SortType.price;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final sortedItems = widget.items.sortedBy(_sortType);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.themeName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          _buildSortToggle(theme),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              itemCount: sortedItems.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = sortedItems[index];
                return _StockRowCard(
                  item: item,
                  onTap: () {
                    // TODO: 종목 상세 페이지로 이동
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortToggle(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          height: 34,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: theme.dividerColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SortPillItem(
                text: '주가순',
                selected: _sortType == SortType.price,
                onTap: () => setState(() => _sortType = SortType.price),
              ),
              _SortPillItem(
                text: '등락률순',
                selected: _sortType == SortType.changeRate,
                onTap: () => setState(() => _sortType = SortType.changeRate),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SortPillItem extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _SortPillItem({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF3B82F6) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : theme.colorScheme.onSurface.withOpacity(0.70),
          ),
        ),
      ),
    );
  }
}

/// 카드형 종목 Row (UI 변경 없음)
class _StockRowCard extends StatelessWidget {
  final ThemeStockItem item;
  final VoidCallback onTap;

  const _StockRowCard({
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isUp = item.change >= 0;
    final rateColor = isUp ? const Color(0xFFE5484D) : const Color(0xFF2F6FED);
    final bgColor = rateColor.withOpacity(0.10);

    return Material(
      color: theme.cardColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.dividerColor.withOpacity(0.16)),
            boxShadow: [
              BoxShadow(
                blurRadius: 12,
                offset: const Offset(0, 6),
                color: Colors.black.withOpacity(0.04),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.code,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.hintColor.withOpacity(0.9),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${_formatInt(item.price)}원',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface.withOpacity(0.92),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${isUp ? '+' : ''}${_formatInt(item.change)}  (${isUp ? '+' : ''}${item.changeRate.toStringAsFixed(2)}%)',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: rateColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Icon(Icons.chevron_right_rounded, color: theme.hintColor.withOpacity(0.7)),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatInt(int n) {
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
