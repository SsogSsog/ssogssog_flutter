import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ssogssog_flutter/core/theme/app_theme.dart';
import 'package:ssogssog_flutter/features/screener/data/model/screener_models.dart';
import 'package:ssogssog_flutter/features/vault/data/repository/strategy_repository.dart';

/// '적용된 필터'의 상세 내용을 보여주는 바텀 시트 위젯
class AppliedFilterBottomSheet extends StatelessWidget {
  final ScreenerRequest? request;

  const AppliedFilterBottomSheet({super.key, this.request});

  @override
  Widget build(BuildContext context) {
    final List<String> appliedFilters = _generateFilterLabels(request);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min, // 콘텐츠 크기만큼만 높이 차지
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 제목과 닫기 버튼
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('적용된 필터', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(
                onPressed: () => Navigator.pop(context), // 바텀 시트 닫기
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text('현재 조건을 저장해 빠르게 불러올 수 있습니다.', style: TextStyle(color: AppColors.greyText)),
          const SizedBox(height: 24),

          // 2. 적용된 필터 칩 목록
          if (appliedFilters.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: Text('적용된 필터가 없습니다.', style: TextStyle(color: Color(0xFF8B93A1)))),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: appliedFilters.map((filter) => _buildFilterChip(filter)).toList(),
            ),
          const SizedBox(height: 32),

          // 3. 하단 버튼
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    context.pop(); // 1. 바텀 시트를 닫음
                    context.pop(); // 2. 검색 결과 페이지를 닫아 필터 설정 페이지로 돌아감
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('필터 수정', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    if (request == null) return;
                    
                    // 저장 API 호출
                    final repo = StrategyRepository();
                    final success = await repo.saveStrategy(request!);

                    if (context.mounted) {
                      if (success) {
                        Navigator.pop(context); // 바텀 시트 닫기
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('전략이 보관함에 저장되었습니다.'),
                            behavior: SnackBarBehavior.floating, // 좀 더 예쁘게
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } else {
                        // 에러 발생 시: 바텀 시트 위에 확실히 뜨도록 다이얼로그(팝업) 사용
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: Colors.white,
                            surfaceTintColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            title: const Row(
                              children: [
                                Icon(Icons.error_outline, color: Color(0xFFE53935)),
                                SizedBox(width: 8),
                                Text('저장 실패', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            content: const Text(
                              '전략 저장 중 문제가 발생했습니다.\n잠시 후 다시 시도해주세요.',
                              style: TextStyle(color: Color(0xFF555555)),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                style: TextButton.styleFrom(
                                  foregroundColor: const Color(0xFF111318),
                                ),
                                child: const Text('확인', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('이 조건 저장', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // 필터 칩을 만드는 위젯
  Widget _buildFilterChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F3FA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF4B4F58), fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(width: 6),
          const Icon(Icons.close, size: 16, color: Color(0xFF8B93A1)),
        ],
      ),
    );
  }

  List<String> _generateFilterLabels(ScreenerRequest? req) {
    if (req == null) return [];
    final list = <String>[];

    // 1. Enums
    if (req.stockPriceRange != null) list.add(_mapPrice(req.stockPriceRange!));
    if (req.marketCapBucket != null) list.add(_mapMarketCap(req.marketCapBucket!));

    // 2. Ranges
    if (req.per != null) list.add(_mapRange('PER', req.per!, '배'));
    if (req.roe != null) list.add(_mapRange('ROE', req.roe!, '%'));
    if (req.operatingProfitRatio != null) list.add(_mapRange('영업이익률', req.operatingProfitRatio!, '%'));
    if (req.debtRatio != null) list.add(_mapRange('부채비율', req.debtRatio!, '%'));
    if (req.dividendYieldRatio != null) list.add(_mapRange('배당수익률', req.dividendYieldRatio!, '%'));
    if (req.foreignOwnershipRate != null) list.add(_mapRange('외국인 보유율', req.foreignOwnershipRate!, '%'));

    // 3. Growth
    if (req.salesGrowthRatio != null) {
      list.add(_mapGrowth('매출액 성장률', req.salesGrowthRatio!, '%'));
    }
    if (req.netProfitGrowthRatio != null) {
      list.add(_mapGrowth('순이익 성장률', req.netProfitGrowthRatio!, '%'));
    }

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

  String _mapGrowth(String name, GrowthCondition cond, String unit) {
    final period = cond.basePeriod == MetricBasePeriod.PREV_YEAR ? '(연간)' : '(분기)';
    if (cond.min != null && cond.max != null) {
      return '$name$period ${_fmtNum(cond.min!)}~${_fmtNum(cond.max!)}$unit';
    } else if (cond.min != null) {
      return '$name$period ${_fmtNum(cond.min!)}$unit 이상';
    }
    return '$name$period 전체';
  }
}
