import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// GoRouter 인스턴스를 final 전역 변수로 둠
final GoRouter router = GoRouter(
  routes: <GoRoute>[
    GoRoute( // routes에 GoRoute 등록
      path: '/', // 루트 경로 진입 시 해당 화면 노출
      builder: (BuildContext context, GoRouterState state) {
        return const Scaffold( // 페이지 반환
          body: Center(child: Text('Home Page')),
        );
      },
    ),
  ],
);
