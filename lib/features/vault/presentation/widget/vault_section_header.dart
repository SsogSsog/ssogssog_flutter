import 'package:flutter/material.dart';
import 'package:ssogssog_flutter/core/theme/app_theme.dart';

/// 보관함의 각 섹션(나의 전략, 관심 종목)의 제목과 부제목을 표시하는 위젯
class VaultSectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const VaultSectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0, bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.greyText,
            ),
          ),
        ],
      ),
    );
  }
}
