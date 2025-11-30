import 'package:flutter/material.dart';
import 'package:ssogssog_flutter/app/routes.dart';
import 'package:ssogssog_flutter/core/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '주식 쏙쏙',
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
