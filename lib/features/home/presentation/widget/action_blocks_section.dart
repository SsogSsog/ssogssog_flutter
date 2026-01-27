import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // [핵심 추가]

/// “필터 대시보드 + 스마트 필터 + 테마별 보기”가 들어가는 섹션을 담당
class ActionBlocksSection extends StatelessWidget {
  const ActionBlocksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: 32.0,
        bottom: 40.0,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 왼쪽 큰 블록
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () => context.push('/screener/view'),
                borderRadius: BorderRadius.circular(24),
                child: const _BigBlock(
                  color: Color(0xFF6FABEB),
                  title: '필터 대시보드',
                  subtitle: '“내 조건으로 쏙쏙\n찾아보기”',
                  imagePath: 'assets/images/home/loupe.png',
                  imageSize: 72,
                ),
              ),
            ),
            const SizedBox(width: 16),

            // 오른쪽 작은 블록 2개
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => context.push('/guru-strategies'),
                      borderRadius: BorderRadius.circular(24),
                      child: const _SmallBlock(
                        color: Color(0xFFB1EBBC),
                        title: '스마트 필터',
                        subtitle: '초보 추천 조합',
                        imagePath: 'assets/images/home/sprout.png',
                        textColor: Colors.black87,
                        imageSize: 40,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // InkWell로 감싸서 탭 기능 추가
                  Expanded(
                    child: InkWell(
                      onTap: () => context.push('/themes'),
                      borderRadius: BorderRadius.circular(24),
                      child: const _SmallBlock(
                        color: Color(0xFFF1D2D2),
                        title: '테마별 보기',
                        subtitle: '요즘 뜨는 섹터',
                        imagePath: 'assets/images/home/tag_rotate.png',
                        textColor: Colors.black87,
                        imageSize: 45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// === 공통 UI 컴포넌트 ===

class _BigBlock extends StatelessWidget {
  final Color color;
  final String title;
  final String subtitle;
  final String imagePath;
  final double imageSize;

  const _BigBlock({
    required this.color,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    this.imageSize = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Image.asset(
              imagePath,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallBlock extends StatelessWidget {
  final Color color;
  final String title;
  final String subtitle;
  final String imagePath;
  final Color textColor;
  final double imageSize;

  const _SmallBlock({
    required this.color,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    this.textColor = Colors.black,
    this.imageSize = 60,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF4C4A4A),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Image.asset(
              imagePath,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
