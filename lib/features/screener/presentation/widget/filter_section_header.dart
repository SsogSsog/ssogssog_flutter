import 'package:flutter/material.dart';

/// 조건 검색 화면에서 '기본 정보', '가치 & 건전성' 등 섹션 제목을 표시하는 위젯
class FilterSectionHeader extends StatelessWidget {
  final String title;

  const FilterSectionHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    // 섹션 간의 구분을 위해 위쪽에 여백을 줍니다.
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
