import 'package:flutter/material.dart';

// 일별시세 데이터 모델
class DailyPriceData {
  final String date;      // "04.05"
  final int closePrice;   // 19070
  final int change;       // -640
  final double changeRate;// -3.00
  final int volume;       // 4265988

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
    _loading = true;

    // 서버에서 데이터를 가져오는 것을 시뮬레이션
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
    setState(() => _dailyPrices.addAll(newItems));
    _loading = false;
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
            itemCount: _dailyPrices.length + 1, // +1: 로딩 인디케이터 영역
            itemBuilder: (context, index) {
              if (index == _dailyPrices.length) {
                // 바닥 로딩
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Center(
                    child: Opacity(
                      opacity: 0.6,
                      child: _loading ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                          : const SizedBox.shrink(),
                    ),
                  ),
                );
              }
              return _DailyPriceRow(data: _dailyPrices[index]);
            },
            separatorBuilder: (context, index) => Divider(
              height: 1,
              thickness: 1,
              color: theme.dividerColor.withOpacity(0.10),
            ),
          ),
        ),
      ],
    );
  }
}

/// 상단 헤더 (목표 UI처럼 밝은 배경 + 얇은 구분선)
class _DailyHeader extends StatelessWidget {
  final ThemeData theme;
  const _DailyHeader({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.65),
        border: Border(
          bottom: BorderSide(color: theme.dividerColor.withOpacity(0.15)),
        ),
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
        color: theme.hintColor.withOpacity(0.90),
      ),
    );
  }
}

/// 일별시세 데이터 한 줄 (목표 UI처럼 "전일대비"를 한 줄로 정리 + 퍼센트는 보조)
class _DailyPriceRow extends StatelessWidget {
  final DailyPriceData data;

  const _DailyPriceRow({required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isUp = data.change > 0;
    final isDown = data.change < 0;

    // 목표 UI처럼 "상승=빨강, 하락=파랑" 유지
    final Color color = isUp
        ? const Color(0xFFFF6B6B) // 살짝 톤다운 레드
        : isDown
        ? const Color(0xFF4D96FF) // 톤다운 블루
        : theme.colorScheme.onSurface.withOpacity(0.55);

    final IconData icon = isUp
        ? Icons.arrow_drop_up
        : isDown
        ? Icons.arrow_drop_down
        : Icons.remove;

    final String changeText = _formatSignedInt(data.change); // +575 / -640
    final String priceText = '${_formatInt(data.closePrice)}원';
    final String volumeText = _formatInt(data.volume);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // 날짜
          Expanded(
            flex: 2,
            child: Text(
              data.date,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.85),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),

          // 종가
          Expanded(
            flex: 3,
            child: Text(
              priceText,
              textAlign: TextAlign.right,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
                letterSpacing: -0.2,
              ),
            ),
          ),

          // 전일대비: (아이콘 + 등락값) + (퍼센트)
          Expanded(
            flex: 4,
            child: Align(
              alignment: Alignment.centerRight,
              child: _ChangeBlock(
                theme: theme,
                color: color,
                icon: icon,
                changeText: changeText,
                rateText: '(${_formatSignedRate(data.changeRate)}%)',
              ),
            ),
          ),

          // 거래량
          Expanded(
            flex: 4,
            child: Text(
              volumeText,
              textAlign: TextAlign.right,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.78),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 4265988 -> 4,265,988
  String _formatInt(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final posFromEnd = s.length - i;
      buf.write(s[i]);
      if (posFromEnd > 1 && posFromEnd % 3 == 1) buf.write(',');
    }
    return buf.toString();
  }

  // +575 / -640 / 0
  String _formatSignedInt(int n) {
    if (n > 0) return '+${_formatInt(n)}';
    if (n < 0) return '-${_formatInt(n.abs())}';
    return '0';
  }

  // +3.00 / -2.50 / 0.00
  String _formatSignedRate(double r) {
    if (r > 0) return '+${r.toStringAsFixed(2)}';
    if (r < 0) return r.toStringAsFixed(2); // 이미 음수 부호 포함
    return '0.00';
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
    // 목표 UI처럼 "등락값은 메인, 퍼센트는 서브" + 정렬 깔끔히
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 2),
            Text(
              changeText,
              style: theme.textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          rateText,
          style: theme.textTheme.labelMedium?.copyWith(
            color: color.withOpacity(0.75),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
