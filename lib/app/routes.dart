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
import 'package:ssogssog_flutter/features/search/presentation/search_page.dart';

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
        // URL에서 stockCode 값을 추출
        final String? stockCode = state.pathParameters['stockCode'];
        if (stockCode == null || stockCode.isEmpty) {
        // 에러 페이지로 리다이렉트하거나 홈으로 이동
          return const Scaffold(
            body: Center(child: Text('잘못된 종목 코드입니다')), // TODO 뒤로 가기 버튼도 만들면 좋음
          );
        }
        return StockDetailPage(stockCode: stockCode);
      },
    ),
    GoRoute(
      path: '/themes',
      builder: (context, state) => const ThemesPage(),
    ),
    GoRoute(
      path: '/search',
      pageBuilder: (context, state) => NoTransitionPage(
        child: const SearchPage(),
      ),
    ),
    // 테마 상세 페이지를 위한 동적 라우트
    GoRoute(
      path: '/themes/:themeName',
      builder: (context, state) {
        final themeName = state.pathParameters['themeName'];
        if (themeName == null || themeName.isEmpty) {
          return const Scaffold(
            body: Center(child: Text('잘못된 테마입니다')),
          );
        }
        return ThemeDetailPage.preview(themeName: themeName);
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
