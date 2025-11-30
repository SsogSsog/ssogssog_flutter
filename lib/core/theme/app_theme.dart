import 'package:flutter/material.dart';

// 앱에서 사용할 색상을 정의하는 클래스
class AppColors {
  static const Color primaryBlue = Color(0xFF3F8CFF);       // 메인 파란색
  static const Color lightBlueBackground = Color(0xFFE9EFFB); // 연한 하늘색 배경
  static const Color white = Colors.white;                   // 흰색
  static const Color black = Colors.black;                   // 검은색
  static const Color greyText = Color(0xFF555555);            // 회색 텍스트
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      
      // 앱의 기본 색상 팔레트 정의
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primaryBlue,
        onPrimary: AppColors.white,
        background: AppColors.lightBlueBackground, // 하늘색 배경 페이지용
        onBackground: AppColors.black,
        surface: AppColors.white,                 // 흰색 배경 페이지 및 카드용
        onSurface: AppColors.black,
        secondary: Colors.lightGreen,             // 보조 색상 (임시)
        onSecondary: AppColors.black,
        error: Colors.redAccent,
        onError: AppColors.white,
      ),

      // 기본 페이지 배경색은 흰색으로 설정
      scaffoldBackgroundColor: AppColors.white,

      // 앱 바(AppBar)의 기본 디자인 설정
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightBlueBackground, // 배경은 하늘색
        elevation: 0,                                   // 그림자 없음
        centerTitle: true,                              // 제목 중앙 정렬
        titleTextStyle: TextStyle(
          color: AppColors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(
          color: AppColors.black, // 뒤로가기 버튼 등 아이콘 색상
        ),
      ),
      
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
