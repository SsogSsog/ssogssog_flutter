import 'package:flutter/material.dart';
import 'package:ssogssog_flutter/app/routes.dart';
import 'package:ssogssog_flutter/core/theme/app_theme.dart';

import 'package:ssogssog_flutter/core/theme/theme_service.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeService(),
      builder: (context, themeMode, _) {
        return MaterialApp.router(
          title: '주식 쏙쏙',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          routerConfig: router,
        );
      },
    );
  }
}
