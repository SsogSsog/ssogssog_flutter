import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ssogssog_flutter/features/screener/data/model/screener_models.dart';
import 'package:ssogssog_flutter/features/screener/presentation/screener_result_page.dart';

class GuruStrategiesPage extends StatelessWidget {
  const GuruStrategiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '대가의 전략',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    '검증된 투자 대가들의\n성공 공식을 만나보세요',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '오랜 시간 검증된 정량적 투자 전략으로\n종목 발굴의 새로운 시각을 얻을 수 있습니다.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildStrategyCard(
              context,
              title: '마법 공식',
              subtitle: '조엘 그린블라트',
              description: '우량한 기업을 싸게 산다\n(ROE 15% 이상, PER 15배 이하)',
              color: const Color(0xFFE8F3FF),
              iconColor: const Color(0xFF55A4ED),
              icon: Icons.auto_graph_rounded,
              request: ScreenerRequest(
                roe: RangeCondition(min: 15),
                per: RangeCondition(max: 15),
              ),
            ),
            const SizedBox(height: 16),
            _buildStrategyCard(
              context,
              title: '고속 성장주',
              subtitle: '피터 린치 스타일',
              description: '폭발적으로 성장하는 기업\n(매출성장 15% 이상, 영업이익률 5% 이상)',
              color: const Color(0xFFFFF4E6),
              iconColor: const Color(0xFFFF9500),
              icon: Icons.rocket_launch_rounded,
              request: ScreenerRequest(
                salesGrowthRatio: GrowthCondition(min: 15),
                operatingProfitRatio: RangeCondition(min: 5),
              ),
            ),
            const SizedBox(height: 16),
            _buildStrategyCard(
              context,
              title: '배당 우량주',
              subtitle: '안전마진 전략',
              description: '망하지 않을 튼튼한 기업\n(배당수익률 3% 이상, 부채비율 100% 이하)',
              color: const Color(0xFFE6F9F0),
              iconColor: const Color(0xFF00C853),
              icon: Icons.security_rounded,
              request: ScreenerRequest(
                dividendYieldRatio: RangeCondition(min: 3),
                debtRatio: RangeCondition(max: 100),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6F8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, size: 20, color: Colors.grey),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '이 전략들은 과거 데이터를 기반으로 한 참고용이며, 투자의 절대적인 기준이 아닙니다. 이 정보로 인한 투자 결과에 대한 법적 책임은 지지 않습니다. 최종 투자 판단은 사용자 본인에게 있습니다.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        height: 1.5,
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

  Widget _buildStrategyCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String description,
    required Color color,
    required Color iconColor,
    required IconData icon,
    required ScreenerRequest request,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          context.push('/screener/result', extra: request);
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFF2F4F6)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: iconColor, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: Colors.grey[400],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF55A4ED), // Primary Color
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
