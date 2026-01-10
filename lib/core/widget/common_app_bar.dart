import 'package:flutter/material.dart';

/// 홈 화면을 제외한 다른 페이지에서 공통으로 사용하는 AppBar
class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CommonAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      // 테마에 정의된 스타일(배경색, 글자 스타일 등)이 자동으로 적용됩니다.
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
