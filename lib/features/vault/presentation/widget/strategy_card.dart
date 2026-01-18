import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ssogssog_flutter/core/theme/app_theme.dart';
import 'package:ssogssog_flutter/features/screener/data/model/screener_models.dart';
import 'package:ssogssog_flutter/features/vault/data/model/strategy_models.dart';

class StrategyCard extends StatelessWidget {
  final Strategy strategy;
  final VoidCallback? onDelete; // 삭제 콜백 추가

  const StrategyCard({
    super.key, 
    required this.strategy,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // 전략 상세 태그 생성
    final tags = _generateTags(strategy);

    return GestureDetector(
      onTap: () {
        // 카드 전체 클릭 시: 검색 결과 페이지로 이동 (실행)
        context.push('/screener/result', extra: strategy.toScreenerRequest());
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상단: 폴더 아이콘 + 제목 + 삭제 버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/home/folder.png',
                          width: 24,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            strategy.strategyName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  
                  // 삭제 버튼 (X 아이콘)
                  GestureDetector(
                    onTap: onDelete,
                    behavior: HitTestBehavior.opaque, // 터치 영역 확보
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.close_rounded,
                        size: 20,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 12),

            // 중단: 태그 리스트
            if (tags.isNotEmpty)
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: tags.map((t) => _buildTag(t)).toList(),
              )
            else
              const Text(
                '설정된 조건 없음',
                style: TextStyle(color: AppColors.greyText, fontSize: 13),
              ),

            const SizedBox(height: 12),

            // 하단: 안내 문구
            const Text(
              '이 조건에 맞는 종목을 지금 확인해보세요',
              style: TextStyle(
                color: AppColors.greyText,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ),
  ); // Missing parenthesis fixed here
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.lightBlueBackground,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.primaryBlue,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }


  // --- Tag Generation Helpers ---
  List<String> _generateTags(Strategy s) {
    final list = <String>[];
    if (s.stockPriceRange != null) list.add(_mapPrice(s.stockPriceRange!));
    if (s.marketCapBucket != null) list.add(_mapMarketCap(s.marketCapBucket!));

    if (s.per != null) list.add(_mapRange('PER', s.per!, '배'));
    if (s.roe != null) list.add(_mapRange('ROE', s.roe!, '%'));
    if (s.operatingProfitMargin != null) list.add(_mapRange('영업이익률', s.operatingProfitMargin!, '%'));
    if (s.netProfitMargin != null) list.add(_mapRange('순이익률', s.netProfitMargin!, '%'));
    if (s.debtRatio != null) list.add(_mapRange('부채비율', s.debtRatio!, '%'));
    if (s.dividendYield != null) list.add(_mapRange('배당수익률', s.dividendYield!, '%'));
    if (s.foreignOwnershipRate != null) list.add(_mapRange('외국인 보유율', s.foreignOwnershipRate!, '%'));

    if (s.salesGrowthQoQ != null) list.add(_mapRange('매출성장(분기)', s.salesGrowthQoQ!, '%'));
    if (s.salesGrowthYoY != null) list.add(_mapRange('매출성장(연간)', s.salesGrowthYoY!, '%'));
    if (s.netProfitGrowthQoQ != null) list.add(_mapRange('순익성장(분기)', s.netProfitGrowthQoQ!, '%'));
    if (s.netProfitGrowthYoY != null) list.add(_mapRange('순익성장(연간)', s.netProfitGrowthYoY!, '%'));

    return list;
  }

  String _mapPrice(StockPriceRange range) {
    switch (range) {
      case StockPriceRange.BELOW_1000: return '1천원 미만';
      case StockPriceRange.FROM_1000_TO_5000: return '1천~5천원';
      case StockPriceRange.FROM_5000_TO_10000: return '5천~1만원';
      case StockPriceRange.FROM_10000_TO_30000: return '1만~3만원';
      case StockPriceRange.FROM_30000_TO_100000: return '3만~10만원';
      case StockPriceRange.ABOVE_100000: return '10만원 이상';
    }
  }

  String _mapMarketCap(MarketCapBucket bucket) {
    switch (bucket) {
      case MarketCapBucket.LARGE_CAP: return '대형주';
      case MarketCapBucket.MID_CAP: return '중형주';
      case MarketCapBucket.SMALL_CAP: return '소형주';
    }
  }

  String _fmtNum(double v) {
    if (v % 1 == 0) return v.toInt().toString();
    return v.toStringAsFixed(1);
  }

  String _mapRange(String name, RangeCondition cond, String unit) {
    if (cond.min != null && cond.max != null) {
      return '$name ${_fmtNum(cond.min!)}~${_fmtNum(cond.max!)}$unit';
    } else if (cond.min != null) {
      return '$name ${_fmtNum(cond.min!)}$unit 이상';
    } else if (cond.max != null) {
      return '$name ${_fmtNum(cond.max!)}$unit 이하';
    }
    return '$name 전체';
  }
}