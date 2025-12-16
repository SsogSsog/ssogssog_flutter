import 'package:flutter/material.dart';
import 'package:ssogssog_flutter/core/theme/app_theme.dart';

class ScreenerResultCard extends StatelessWidget {
  const ScreenerResultCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 왼쪽: 종목 정보
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('큐로홀딩스', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('051780', style: TextStyle(fontSize: 13, color: AppColors.greyText)),
                // TODO: 여기에 태그가 들어올 수 있습니다.
              ],
            ),
          ),
          // 오른쪽: 가격 정보 및 즐겨찾기
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('1,236', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('+29.97%', style: TextStyle(fontSize: 14, color: Colors.red, fontWeight: FontWeight.w600)),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.bar_chart, size: 16, color: AppColors.greyText),
                      SizedBox(width: 4),
                      Text('2,517,785', style: TextStyle(color: AppColors.greyText, fontSize: 12)),
                    ],
                  )
                ],
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.star_border, color: AppColors.greyText),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
