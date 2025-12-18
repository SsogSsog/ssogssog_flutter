import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ssogssog_flutter/core/widget/bottom_tap_scaffold.dart';
import 'package:ssogssog_flutter/features/home/presentation/home_page.dart';
import 'package:ssogssog_flutter/features/screener/presentation/screener_page.dart';
import 'package:ssogssog_flutter/features/screener/presentation/screener_result_page.dart'; // [추가]
import 'package:ssogssog_flutter/features/settings/presentation/settings_page.dart';
import 'package:ssogssog_flutter/features/vault/presentation/vault_page.dart';

// 앱의 라우팅 설정을 담당하는 GoRouter 객체
final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    // 하단 탭이 있는 페이지들을 위한 ShellRoute
    ShellRoute(
      builder: (context, state, navigationShell) {
        return BottomTapScaffold(child: navigationShell);
      },
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomePage(),
          ),
        ),
        GoRoute(
          path: '/screener',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ScreenerPage(),
          ),
        ),
        GoRoute(
          path: '/vault',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: VaultPage(),
          ),
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SettingsPage(),
          ),
        ),
      ],
    ),

    // 하단 탭이 없는 독립적인 페이지들
    GoRoute(
      path: '/screener/result',
      builder: (context, state) => const ScreenerResultPage(),
    ),
  ],
);
