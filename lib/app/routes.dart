import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ssogssog_flutter/core/widget/bottom_tap_scaffold.dart';
import 'package:ssogssog_flutter/features/home/presentation/home_page.dart';
import 'package:ssogssog_flutter/features/screener/presentation/screener_page.dart';
import 'package:ssogssog_flutter/features/settings/presentation/settings_page.dart';
import 'package:ssogssog_flutter/features/vault/presentation/vault_page.dart';

// 앱의 라우팅 설정을 담당하는 GoRouter 객체
// 앱 전체의 라우팅 엔진!
final GoRouter router = GoRouter(
  // 앱의 초기 경로 설정
  initialLocation: '/',

  routes: [
    // ShellRoute는 여러 라우트를 하나의 공통 UI(shell)로 감싸는 역할을 합니다.
    // 여기서는 BottomTapScaffold를 공통 UI로 사용하여 하단 네비게이션을 구현합니다.
    ShellRoute(
      // builder는 공통 UI를 만드는 함수입니다.
      // navigationShell은 자식 라우트(페이지)가 렌더링될 위젯입니다.
      builder: (context, state, navigationShell) {
        return BottomTapScaffold(child: navigationShell); // UI + child 연결
      },
      // ex) HomePage 등 다른 페이지로 이동할 때 BottomTapScaffold(body:HomePage()) 가 아닌 저절로 UI 연결해줌

      // ShellRoute에 의해 감싸질 자식 라우트 목록
      routes: [
        // 홈 화면 라우트
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
        ),
        // 조건검색 화면 라우트
        GoRoute(
          path: '/screener',
          builder: (context, state) => const ScreenerPage(),
        ),
        // 보관함 화면 라우트
        GoRoute(
          path: '/vault',
          builder: (context, state) => const VaultPage(),
        ),
        // 설정 화면 라우트
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsPage(),
        ),
      ],
    ),
  ],
);
