import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ssogssog_flutter/features/home/data/model/home_ranking_models.dart';
import 'package:ssogssog_flutter/features/home/data/repository/home_repository.dart';

class MarketRankingSection extends StatefulWidget {
  const MarketRankingSection({super.key});

  @override
  State<MarketRankingSection> createState() => _MarketRankingSectionState();
}

class _MarketRankingSectionState extends State<MarketRankingSection> {
  final HomeRepository _repository = HomeRepository();

  // 현재 선택된 탭 (0: 급상승, 1: 급하락, 2: 거래량)
  int _selectedIndex = 0;

  // 탭 메뉴 이름들
  final List<String> _tabs = ['🚀 급상승', '💧 급하락', '🔥 거래량'];

  // 데이터 캐싱 (Key: Tab Index, Value: List<StockRankingItem>)
  final Map<int, List<StockRankingItem>> _cachedData = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _preloadAllData(); // 초기 데이터 일괄 로드
  }

  /// 모든 탭의 데이터를 병렬로 미리 가져옵니다.
  Future<void> _preloadAllData() async {
    setState(() => _isLoading = true);

    try {
      // 0: 급상승, 1: 급하락, 2: 거래량
      final results = await Future.wait([
        _repository.getRisingStocks(),
        _repository.getFallingStocks(),
        _repository.getVolumeStocks(),
      ]);

      if (mounted) {
        setState(() {
          _cachedData[0] = results[0];
          _cachedData[1] = results[1];
          _cachedData[2] = results[2];
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error preloading data: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchData(int index) async {
    if (_cachedData.containsKey(index)) return; // 이미 데이터가 있으면 패스

    setState(() => _isLoading = true);

    List<StockRankingItem> result = [];
    try {
      if (index == 0) {
        result = await _repository.getRisingStocks();
      } else if (index == 1) {
        result = await _repository.getFallingStocks();
      } else {
        result = await _repository.getVolumeStocks();
      }
    } catch (e) {
      print('Error loading ranking data: $e');
    }

    if (mounted) {
      setState(() {
        _cachedData[index] = result;
        _isLoading = false;
      });
    }
  }

  void _onTabChanged(int index) {
    setState(() => _selectedIndex = index);
    _fetchData(index);
  }

  @override
  Widget build(BuildContext context) {
    final currentList = _cachedData[_selectedIndex] ?? [];

    return Column(
      children: [
        // 1. 회색 구분선
        const Divider(color: Color(0xFFEEEEEE), thickness: 6, height: 6),
        const SizedBox(height: 32),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 2. 섹션 제목
              const Row(
                children: [
                  Text(
                    '실시간 시장 랭킹 ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 3. 탭 버튼
              Container(
                height: 45,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F4F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: List.generate(_tabs.length, (index) {
                    final isSelected = _selectedIndex == index;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => _onTabChanged(index),
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    )
                                  ]
                                : [],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _tabs[index],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight:
                                  isSelected ? FontWeight.w800 : FontWeight.w500,
                              color: isSelected
                                  ? const Color(0xFF6FABEB)
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 20),

              // 4. 주식 리스트
              if (_isLoading && currentList.isEmpty)
                const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator.adaptive()),
                )
              else if (currentList.isEmpty)
                const SizedBox(
                  height: 200,
                  child: Center(child: Text('데이터가 없습니다.')),
                )
              else
                _buildRankingList(currentList),

              const SizedBox(height: 40), // 하단 여백
            ],
          ),
        ),
      ],
    );
  }

  // 랭킹 리스트 빌더
  Widget _buildRankingList(List<StockRankingItem> items) {
    return Column(
      children: List.generate(items.length, (index) {
        final item = items[index];
        final rank = item.rank > 0 ? item.rank : index + 1; // API 랭크가 0이면 인덱스 사용
        
        // 등락률에 따른 색상 결정 (상승: 빨강, 하락: 파랑, 보합: 검정/회색)
        Color rateColor;
        Color rateBgColor;
        if (item.changeRate > 0) {
          rateColor = const Color(0xFFFF6B6B);
          rateBgColor = const Color(0xFFFFEBEE);
        } else if (item.changeRate < 0) {
          rateColor = const Color(0xFF4D96FF);
          rateBgColor = const Color(0xFFE3F2FD);
        } else {
          rateColor = Colors.grey;
          rateBgColor = Colors.grey[200]!;
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: InkWell(
            onTap: () {
              // TODO: 종목 상세 이동 (GoRouter 사용 등)
              // context.push('/stock/${item.stockCode}');
            },
            child: Row(
              children: [
                // 순위
                SizedBox(
                  width: 24,
                  child: Text(
                    '$rank',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: rank <= 3 ? const Color(0xFF6FABEB) : Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // 종목명 & 코드
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.corpName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        item.stockCode,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),

                // 가격 & 등락률
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${NumberFormat('#,###').format(item.currentPrice)}원',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: rateBgColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${item.changeRate > 0 ? '+' : ''}${item.changeRate}%',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: rateColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
