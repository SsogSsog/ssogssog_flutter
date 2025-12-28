import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // [핵심 추가]

// 일별시세 데이터 모델
class DailyPriceData {
  final String date;
  final int closePrice;
  final int change;
  final double changeRate;
  final int volume;

  const DailyPriceData({
    required this.date,
    required this.closePrice,
    required this.change,
    required this.changeRate,
    required this.volume,
  });
}

/// 종목 상세 - '일별시세' 탭 위젯
class DailyPriceTab extends StatefulWidget {
  const DailyPriceTab({super.key});

  @override
  State<DailyPriceTab> createState() => _DailyPriceTabState();
}

class _DailyPriceTabState extends State<DailyPriceTab> {
  final List<DailyPriceData> _dailyPrices = [];
  final ScrollController _scrollController = ScrollController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadMoreData();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 80) {
        _loadMoreData();
      }
    });
  }

  Future<void> _loadMoreData() async {
    if (_loading) return;
    setState(() => _loading = true);

    await Future.delayed(const Duration(milliseconds: 200));

    final List<DailyPriceData> newItems = List.generate(20, (index) {
      final sign = index % 3 == 0 ? -1 : 1;
      return DailyPriceData(
        date: '04.${(5 - index % 5).toString().padLeft(2, '0')}',
        closePrice: 19070 + (index * 100 * sign),
        change: -640 + (index * 50 * sign),
        changeRate: -3.00 + (index * 0.5 * sign),
        volume: 4265988 + (index * 10000),
      );
    });

    if (!mounted) return;
    setState(() {
      _dailyPrices.addAll(newItems);
      _loading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        _DailyHeader(theme: theme),
        Expanded(
          child: ListView.separated(
            controller: _scrollController,
            itemCount: _dailyPrices.length + (_loading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _dailyPrices.length) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Center(
                    child: Opacity(
                      opacity: 0.6,
                      child: const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2)),
                    ),
                  ),
                );
              }
              return _DailyPriceRow(data: _dailyPrices[index]);
            },
            separatorBuilder: (context, index) => Divider(
              height: 1,
              thickness: 1,
              color: theme.dividerColor.withAlpha((0.10 * 255).round()),
            ),
          ),
        ),
      ],
    );
  }
}

class _DailyHeader extends StatelessWidget {
  final ThemeData theme;
  const _DailyHeader({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withAlpha((0.65 * 255).round()),
        border: Border(bottom: BorderSide(color: theme.dividerColor.withAlpha((0.15 * 255).round()))),
      ),
      child: const Row(
        children: [
          Expanded(flex: 2, child: _HeaderText('날짜', align: TextAlign.left)),
          Expanded(flex: 3, child: _HeaderText('종가', align: TextAlign.right)),
          Expanded(flex: 4, child: _HeaderText('전일대비', align: TextAlign.right)),
          Expanded(flex: 4, child: _HeaderText('거래량', align: TextAlign.right)),
        ],
      ),
    );
  }
}

class _HeaderText extends StatelessWidget {
  final String text;
  final TextAlign align;
  const _HeaderText(this.text, {required this.align});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      textAlign: align,
      style: theme.textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w800,
        color: theme.hintColor.withAlpha((0.90 * 255).round()),
      ),
    );
  }
}

class _DailyPriceRow extends StatelessWidget {
  final DailyPriceData data;

  const _DailyPriceRow({required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUp = data.change > 0;
    final isDown = data.change < 0;
    final Color color = isUp ? const Color(0xFFFF6B6B) : (isDown ? const Color(0xFF4D96FF) : theme.colorScheme.onSurface.withAlpha((0.55 * 255).round()));
    final IconData icon = isUp ? Icons.arrow_drop_up : (isDown ? Icons.arrow_drop_down : Icons.remove);

    final String changeText = _formatSignedInt(data.change);
    final String priceText = '${_formatInt(data.closePrice)}원';
    final String volumeText = _formatInt(data.volume);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(data.date, style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface.withAlpha((0.85 * 255).round()), fontWeight: FontWeight.w400)),
          ),
          Expanded(
            flex: 3,
            child: Text(priceText, textAlign: TextAlign.right, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500, letterSpacing: -0.2)),
          ),
          Expanded(
            flex: 4,
            child: Align(
              alignment: Alignment.centerRight,
              child: _ChangeBlock(theme: theme, color: color, icon: icon, changeText: changeText, rateText: '(${_formatSignedRate(data.changeRate)}%)'),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(volumeText, textAlign: TextAlign.right, style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface.withAlpha((0.78 * 255).round()), fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  // [핵심 수정] intl 패키지를 사용하여 숫자 포맷팅
  String _formatInt(int n) {
    return NumberFormat('#,###').format(n);
  }

  String _formatSignedInt(int n) {
    if (n > 0) return '+${_formatInt(n)}';
    if (n < 0) return '${_formatInt(n)}';
    return '0';
  }

  String _formatSignedRate(double r) {
    if (r > 0) return '+${r.toStringAsFixed(2)}';
    return r.toStringAsFixed(2);
  }
}

class _ChangeBlock extends StatelessWidget {
  final ThemeData theme;
  final Color color;
  final IconData icon;
  final String changeText;
  final String rateText;

  const _ChangeBlock({
    required this.theme,
    required this.color,
    required this.icon,
    required this.changeText,
    required this.rateText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 2),
            Text(changeText, style: theme.textTheme.titleMedium?.copyWith(color: color, fontWeight: FontWeight.w800, letterSpacing: -0.2)),
          ],
        ),
        const SizedBox(height: 3),
        Text(rateText, style: theme.textTheme.labelMedium?.copyWith(color: color.withAlpha((0.75 * 255).round()), fontWeight: FontWeight.w600)),
      ],
    );
  }
}
