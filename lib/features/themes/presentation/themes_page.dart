import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TrendingTheme {
  final String icon; // emoji
  final String name;
  final double changeRate;
  final int stockCount;

  const TrendingTheme({
    required this.icon,
    required this.name,
    required this.changeRate,
    required this.stockCount,
  });
}

/// 요즘 뜨는 테마 목록을 보여주는 페이지
class ThemesPage extends StatelessWidget {
  const ThemesPage({super.key});

  static const List<TrendingTheme> _dummyThemes = [
    TrendingTheme(icon: '💾', name: '반도체 대장주', changeRate: 3.2, stockCount: 12),
    TrendingTheme(icon: '🔋', name: '2차전지/배터리', changeRate: -1.5, stockCount: 25),
    TrendingTheme(icon: '🤖', name: 'AI / 로봇', changeRate: 5.1, stockCount: 31),
    TrendingTheme(icon: '💊', name: '바이오 / 제약', changeRate: 0.2, stockCount: 58),
    TrendingTheme(icon: '🚗', name: '자동차 부품', changeRate: -0.5, stockCount: 18),
    TrendingTheme(icon: '🛒', name: '소비재 / 유통', changeRate: 1.1, stockCount: 22),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '요즘 뜨는 테마 (Themes)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        // centerTitle: true, // 취향이면 켜도 됨
      ),
      body: SafeArea(
        child: Column(
          children: [
            _SearchBar(theme: theme),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  // 기존 0.9는 높이가 조금 답답해 보일 수 있어서 살짝 여유
                  childAspectRatio: 0.92,
                ),
                itemCount: _dummyThemes.length,
                itemBuilder: (context, index) {
                  return _ThemeCard(themeItem: _dummyThemes[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final ThemeData theme;
  const _SearchBar({required this.theme});

  @override
  Widget build(BuildContext context) {
    final fill = theme.colorScheme.surface;
    final border = theme.dividerColor.withOpacity(0.10);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
      child: Container(
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: '테마 또는 종목 검색',
            prefixIcon: Icon(Icons.search, color: theme.hintColor.withOpacity(0.8)),
            filled: true,
            fillColor: Colors.transparent,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }
}

/// 테마 하나를 표시하는 카드 위젯
class _ThemeCard extends StatelessWidget {
  final TrendingTheme themeItem;

  const _ThemeCard({required this.themeItem});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isUp = themeItem.changeRate >= 0;
    final rateColor = isUp ? Colors.red.shade400 : Colors.blue.shade500;

    final cardBorder = theme.dividerColor.withOpacity(0.12);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          final encodedThemeName = Uri.encodeComponent(themeItem.name);
          context.push('/themes/$encodedThemeName');
        },
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: cardBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.035),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상단: 아이콘 + 변동률 배지
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _EmojiBadge(emoji: themeItem.icon),
                  _RatePill(
                    isUp: isUp,
                    value: themeItem.changeRate,
                    color: rateColor,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // 중단: 테마명
              Text(
                themeItem.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                ),
              ),

              const Spacer(),

              Align(
                alignment: Alignment.center,
                child: Text(
                  '${themeItem.stockCount}개 종목',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface.withOpacity(0.72),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmojiBadge extends StatelessWidget {
  final String emoji;
  const _EmojiBadge({required this.emoji});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 42,
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.dividerColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        emoji,
        style: const TextStyle(fontSize: 22),
      ),
    );
  }
}

class _RatePill extends StatelessWidget {
  final bool isUp;
  final double value;
  final Color color;

  const _RatePill({
    required this.isUp,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // 표시 포맷 정리(항상 소수 1자리)
    final text = '${isUp ? '+' : ''}${value.toStringAsFixed(1)}%';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isUp ? Icons.arrow_drop_up : Icons.arrow_drop_down,
            size: 18,
            color: color,
          ),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w900,
              fontSize: 13,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
