import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ssogssog_flutter/features/themes/data/model/theme_models.dart';
import 'package:ssogssog_flutter/features/themes/data/repository/theme_repository.dart';

/// 요즘 뜨는 테마 목록을 보여주는 페이지
class ThemesPage extends StatefulWidget {
  const ThemesPage({super.key});

  @override
  State<ThemesPage> createState() => _ThemesPageState();
}

class _ThemesPageState extends State<ThemesPage> {
  final ThemeRepository _repository = ThemeRepository();
  late Future<ThemeStatsResult?> _futureResult;

  @override
  void initState() {
    super.initState();
    _futureResult = _repository.getThemeStats();
  }

  Future<void> _refresh() async {
    setState(() {
      _futureResult = _repository.getThemeStats();
    });
    await _futureResult;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '요즘 뜨는 테마 (Themes)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _SearchBar(theme: theme),
            Expanded(
              child: FutureBuilder<ThemeStatsResult?>(
                future: _futureResult,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('오류 발생: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data?.items.isEmpty == true) {
                    return const Center(child: Text('등록된 테마가 없습니다.'));
                  }

                  final data = snapshot.data!;
                  final items = data.items;

                  return RefreshIndicator(
                    onRefresh: _refresh,
                    child: GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.92,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return _ThemeCard(themeItem: items[index]);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// TODO: 검색 기능 구현 필요
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
          readOnly: true,
          onTap: () => context.push('/search'),
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
  final ThemeItem themeItem;

  const _ThemeCard({required this.themeItem});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isUp = themeItem.changeRateAverage >= 0;
    final rateColor = isUp ? Colors.red.shade400 : Colors.blue.shade500;

    final cardBorder = theme.dividerColor.withOpacity(0.12);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          final encodedThemeName = Uri.encodeComponent(themeItem.themeName);
          context.push('/themes/$encodedThemeName', extra: themeItem);
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
                  _EmojiBadge(emoji: themeItem.emoji),
                  _RatePill(
                    isUp: isUp,
                    value: themeItem.changeRateAverage,
                    color: rateColor,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // 중단: 테마명
              Text(
                themeItem.themeName,
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
                  '${themeItem.totalCount}개 종목',
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
