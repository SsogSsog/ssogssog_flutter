import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ssogssog_flutter/core/widget/bottom_tap_scaffold.dart';
import 'package:ssogssog_flutter/features/home/presentation/home_page.dart';
import 'package:ssogssog_flutter/features/screener/presentation/screener_page.dart';
import 'package:ssogssog_flutter/features/screener/presentation/screener_result_page.dart';
import 'package:ssogssog_flutter/features/settings/presentation/settings_page.dart';
import 'package:ssogssog_flutter/features/stock_detail/presentation/stock_detail_page.dart';
import 'package:ssogssog_flutter/features/themes/presentation/theme_detail_page.dart';
import 'package:ssogssog_flutter/features/themes/presentation/themes_page.dart';
import 'package:ssogssog_flutter/features/vault/presentation/vault_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, navigationShell) {
        return BottomTapScaffold(child: navigationShell);
      },
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => NoTransitionPage(
            child: const HomePage(),
          ),
        ),
        GoRoute(
          path: '/screener',
          pageBuilder: (context, state) => NoTransitionPage(
            child: const ScreenerPage(),
          ),
        ),
        GoRoute(
          path: '/vault',
          pageBuilder: (context, state) => NoTransitionPage(
            child: const VaultPage(),
          ),
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) => NoTransitionPage(
            child: const SettingsPage(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/screener/result',
      builder: (context, state) => const ScreenerResultPage(),
    ),
    GoRoute(
      path: '/stock/:stockCode',
      builder: (context, state) {
        final String stockCode = state.pathParameters['stockCode']!;
        return StockDetailPage(stockCode: stockCode);
      },
    ),
    GoRoute(
      path: '/themes',
      builder: (context, state) => const ThemesPage(),
    ),
    // 테마 상세 페이지를 위한 동적 라우트
    GoRoute(
      path: '/themes/:themeName',
      builder: (context, state) {
        final themeName = state.pathParameters['themeName']!;
        // go_router는 파라미터를 자동으로 디코딩해주므로, 중복 디코딩을 제거합니다.
        //return ThemeDetailPage(themeName: themeName);
        return ThemeDetailPage.preview(themeName: themeName); // 임시 데이터 대입
      },
    ),
  ],
);

class NoTransitionPage<T> extends CustomTransitionPage<T> {
  NoTransitionPage({
    required super.child,
    super.name,
    super.arguments,
    super.restorationId,
    super.key,
  }) : super(
          transitionsBuilder: (_, __, ___, child) => child,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        );
}
