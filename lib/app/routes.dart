import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ssogssog_flutter/core/widget/bottom_tap_scaffold.dart';
import 'package:ssogssog_flutter/features/home/presentation/home_page.dart';
import 'package:ssogssog_flutter/features/screener/presentation/screener_page.dart';
import 'package:ssogssog_flutter/features/screener/presentation/screener_result_page.dart';
import 'package:ssogssog_flutter/features/settings/presentation/settings_page.dart';
import 'package:ssogssog_flutter/features/stock_detail/presentation/stock_detail_page.dart';
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
    // 종목 상세 페이지를 위한 동적 라우트
    GoRoute(
      path: '/stock/:stockCode', // ':'는 이 부분이 변수임을 의미
      builder: (context, state) {
        // URL에서 stockCode 값을 추출
        final String stockCode = state.pathParameters['stockCode']!;
        return StockDetailPage(stockCode: stockCode);
      },
    ),
  ],
);

// 화면 전환 애니메이션을 없애기 위한 CustomTransitionPage
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
