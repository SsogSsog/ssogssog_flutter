import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ssogssog_flutter/core/theme/app_theme.dart';
import 'package:ssogssog_flutter/core/widget/common_app_bar.dart';
import 'package:ssogssog_flutter/core/widget/pill_toggle.dart';
import 'package:ssogssog_flutter/features/screener/data/model/screener_models.dart';
import 'package:ssogssog_flutter/features/screener/presentation/widget/filter_chip_group.dart';
import 'package:ssogssog_flutter/features/screener/presentation/widget/filter_range_slider.dart';
import 'package:ssogssog_flutter/features/screener/presentation/widget/filter_slider.dart';

class ScreenerPage extends StatefulWidget {
  const ScreenerPage({super.key});

  @override
  State<ScreenerPage> createState() => _ScreenerPageState();
}

class _ScreenerPageState extends State<ScreenerPage> {
  static const double _pageH = 20;

  // --- State Variables ---

  // 1. 기본 정보
  String? _selectedPriceLabel;
  String? _selectedMarketCapLabel;

  // 2. 가치/재무 (Min Value)
  double? _perMin;
  double? _roeMin;
  double? _operatingProfitMin;
  double? _debtRatioMax; // 부채비율은 보통 '이하라면 좋다'가 많지만 여기선 슬라이더 UI에 따라 결정. 일단 Slider가 '이상' 로직이면 Min.
  // 확인 결과: FilterSlider는 "X 이상"을 표시함. 
  // 그러나 부채비율은 "X 이하"가 좋은 필터일 수 있음. 기획 확인 필요.
  // 일단 기존 UI 로직(이상)을 따르되, 사용자가 전체 범위를 선택하면 null 처리.
  double? _dividendYieldMin;

  // 3. 성장/수급 (Range Value & Period)
  RangeValues? _salesGrowthRange;
  MetricBasePeriod _salesGrowthPeriod = MetricBasePeriod.PREV_YEAR;

  double? _netProfitGrowthMin; // UI에 FilterSlider로 되어 있음
  MetricBasePeriod _netProfitGrowthPeriod = MetricBasePeriod.PREV_YEAR;

  RangeValues? _foreignOwnershipRange;

  // --- Mapping Logic ---

  StockPriceRange? _mapPrice(String? label) {
    if (label == null) return null;
    switch (label) {
      case '1천원 미만': return StockPriceRange.BELOW_1000;
      case '1천~5천원': return StockPriceRange.FROM_1000_TO_5000;
      case '5천~1만원': return StockPriceRange.FROM_5000_TO_10000;
      case '1만~3만원': return StockPriceRange.FROM_10000_TO_30000;
      case '3만~10만원': return StockPriceRange.FROM_30000_TO_100000;
      case '10만원 이상': return StockPriceRange.ABOVE_100000;
      default: return null;
    }
  }

  MarketCapBucket? _mapMarketCap(String? label) {
    if (label == null) return null;
    switch (label) {
      case '대형주': return MarketCapBucket.LARGE_CAP;
      case '중형주': return MarketCapBucket.MID_CAP;
      case '소형주': return MarketCapBucket.SMALL_CAP;
      default: return null;
    }
  }

  RangeCondition? _makeRange(double? val, double sliderMin, double sliderMax, {bool isMax = false}) {
    if (val == null) return null;
    // 슬라이더가 최소값(또는 전체)에 있으면 필터 미적용으로 간주
    if (val <= sliderMin) return null;
    
    // "X 이상" 조건
    return RangeCondition(min: val);
  }

  RangeCondition? _makeRangeFromValues(RangeValues? val, double sliderMin, double sliderMax) {
    if (val == null) return null;
    // 전체 범위 선택 시 필터 미적용
    if (val.start <= sliderMin && val.end >= sliderMax) return null;
    
    return RangeCondition(min: val.start, max: val.end >= sliderMax ? null : val.end);
  }

  void _onSearchPressed() {
    final request = ScreenerRequest(
      stockPriceRange: _mapPrice(_selectedPriceLabel),
      marketCapBucket: _mapMarketCap(_selectedMarketCapLabel),
      
      per: _makeRange(_perMin, 0, 50),
      roe: _makeRange(_roeMin, 0, 30),
      operatingProfitRatio: _makeRange(_operatingProfitMin, 0, 50),
      debtRatio: _makeRange(_debtRatioMax, 0, 300), // TODO: 부채비율 로직 점검 필요
      dividendYieldRatio: _makeRange(_dividendYieldMin, 0, 10),
      
      salesGrowthRatio: _makeGrowthFromRange(_salesGrowthRange, 0, 100, _salesGrowthPeriod),
      netProfitGrowthRatio: _makeGrowth(_netProfitGrowthMin, 0, 100, _netProfitGrowthPeriod),
      
      foreignOwnershipRate: _makeRangeFromValues(_foreignOwnershipRange, 0, 100),
    );

    context.push('/screener/result', extra: request);
  }

  GrowthCondition? _makeGrowth(double? val, double min, double max, MetricBasePeriod period) {
    if (val == null || val <= min) return null;
    return GrowthCondition(min: val, basePeriod: period); // 이상 조건
  }

  GrowthCondition? _makeGrowthFromRange(RangeValues? val, double min, double max, MetricBasePeriod period) {
    if (val == null) return null;
    if (val.start <= min && val.end >= max) return null;
    return GrowthCondition(min: val.start, max: val.end >= max ? null : val.end, basePeriod: period);
  }

  Widget _buildPeriodToggle(MetricBasePeriod current, ValueChanged<MetricBasePeriod> onChanged) {
    return PillToggle(
      left: '연간',
      right: '분기',
      isLeftSelected: current == MetricBasePeriod.PREV_YEAR,
      onChanged: (isLeft) {
        onChanged(isLeft ? MetricBasePeriod.PREV_YEAR : MetricBasePeriod.PREV_QUARTER);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // ... UI build logic needs to bind to state
    return Scaffold(
      appBar: const CommonAppBar(title: '필터 설정'),
      backgroundColor: const Color(0xFFF6F7FB),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(_pageH, 16, _pageH, 120),
        children: [
          const _InfoBanner(
            text: '아래의 필터로 주식을 검색할 수 있습니다. 기준 값은 전일종가 기준으로 계산됩니다.',
          ),
          const SizedBox(height: 12),

          _SectionCard(
            title: '기본 정보',
            subtitle: '아무것도 선택하지 않으면 전체 종목을 대상으로 합니다.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FilterChipGroup(
                  title: '가격',
                  options: const [
                    '1천원 미만', '1천~5천원', '5천~1만원',
                    '1만~3만원', '3만~10만원', '10만원 이상'
                  ],
                  columns: 3,
                  onSelected: (selected) => setState(() => _selectedPriceLabel = selected),
                ),
                const SizedBox(height: 20),
                FilterChipGroup(
                  title: '시가총액',
                  options: const ['대형주', '중형주', '소형주'],
                  columns: 3,
                  onSelected: (selected) => setState(() => _selectedMarketCapLabel = selected),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          _SectionCard(
            title: '가치 · 재무',
            child: Column(
              children: [
                FilterSlider(
                  title: 'PER',
                  subtitle: '주가수익비율',
                  min: 0,
                  max: 50,
                  step: 1,
                  unit: '배',
                  onChanged: (value) => setState(() => _perMin = value),
                ),
                const SizedBox(height: 16),
                FilterSlider(
                  title: 'ROE',
                  subtitle: '자기자본이익률',
                  min: 0,
                  max: 30,
                  step: 1,
                  unit: '%',
                  onChanged: (value) => setState(() => _roeMin = value),
                ),
                const SizedBox(height: 16),
                FilterSlider(
                  title: '영업이익률',
                  subtitle: '매출액 대비 영업이익',
                  min: 0,
                  max: 50,
                  step: 1,
                  unit: '%',
                  onChanged: (value) => setState(() => _operatingProfitMin = value),
                ),
                const SizedBox(height: 16),
                FilterSlider(
                  title: '부채비율',
                  subtitle: '',
                  min: 0,
                  max: 300,
                  step: 10,
                  unit: '%',
                  onChanged: (value) => setState(() => _debtRatioMax = value),
                ),
                const SizedBox(height: 16),
                FilterSlider(
                  title: '배당수익률',
                  subtitle: '주가 대비 배당금',
                  min: 0,
                  max: 10,
                  step: 0.5,
                  unit: '%',
                  onChanged: (value) => setState(() => _dividendYieldMin = value),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          _SectionCard(
            title: '성장 · 수급',
            child: Column(
              children: [
                FilterRangeSlider(
                  title: '매출액 성장률',
                  subtitle: '',
                  min: 0,
                  max: 100,
                  step: 5,
                  unit: '%',
                  headerAction: _buildPeriodToggle(
                    _salesGrowthPeriod, 
                    (v) => setState(() => _salesGrowthPeriod = v)
                  ),
                  onChanged: (values) => setState(() => _salesGrowthRange = values),
                ),
                const SizedBox(height: 16),
                FilterSlider(
                  title: '순이익 성장률',
                  subtitle: '',
                  min: 0,
                  max: 100,
                  step: 5,
                  unit: '%',
                  headerAction: _buildPeriodToggle(
                    _netProfitGrowthPeriod, 
                    (v) => setState(() => _netProfitGrowthPeriod = v)
                  ),
                  onChanged: (value) => setState(() => _netProfitGrowthMin = value),
                ),
                const SizedBox(height: 16),
                FilterRangeSlider(
                  title: '외국인 보유율',
                  subtitle: '',
                  min: 0,
                  max: 100,
                  step: 5,
                  unit: '%',
                  onChanged: (values) => setState(() => _foreignOwnershipRange = values),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _BottomApplyBar(
        label: '검색하기',
        onPressed: _onSearchPressed,
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;

  const _SectionCard({
    required this.title,
    this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // ... Existing UI code
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDEFF5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),

          if (subtitle != null) ...[
            const SizedBox(height: 6),
            Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 12.5,
                height: 1.3,
                color: Color(0xFF8B93A1),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],

          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}


class _BottomApplyBar extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _BottomApplyBar({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    // ... Existing UI code
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            offset: Offset(0, -6),
            color: Color(0x14000000),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 52,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
            child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          ),
        ),
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  final String text;

  const _InfoBanner({required this.text});

  @override
  Widget build(BuildContext context) {
    // ... Existing UI code
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEDEFF5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(Icons.tune, size: 18, color: Color(0xFF8B93A1)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                height: 1.35,
                color: Color(0xFF2E3137),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
