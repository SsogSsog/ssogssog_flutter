import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// implements PreferredSizeWidget 사용 시 Scaffold에 들어가는 위젯은 크기를 알고 있어야 한다.
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  // 원하는 앱바 높이 한 번에 관리
  static const double _appBarHeight = 80;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // AppBar의 배경색을 페이지 배경색과 맞춤
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,

      toolbarHeight: _appBarHeight,
      centerTitle: false,
      titleSpacing: 0,

      title: Transform.translate(
        offset: const Offset(-20, 0), // 왼쪽으로 더 강제로 이동
        child: Image.asset(
          'assets/images/logo/text_logo.png',
          height: 150, // 높이는 충분히 주어 fit에 의해 꽉 차게 만듦
          fit: BoxFit.contain,
          alignment: Alignment.centerLeft,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.black, size: 28),
          onPressed: () {
            context.push('/search');
          },
        ),
      ],
    );
  }

  // PreferredSizeWidget을 구현하면 반드시 이 getter를 구현해야 한다.
  @override
  Size get preferredSize => const Size.fromHeight(_appBarHeight); //kToolbarHeight: flutter에서 재공한 기본 툴바 높이
}
