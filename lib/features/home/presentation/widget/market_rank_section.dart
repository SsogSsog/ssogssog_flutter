import 'package:flutter/material.dart';

class MarketRankingSection extends StatefulWidget {
  const MarketRankingSection({super.key});

  @override
  State<MarketRankingSection> createState() => _MarketRankingSectionState();
}

class _MarketRankingSectionState extends State<MarketRankingSection> {
  // 현재 선택된 탭 (0: 급상승, 1: 급하락, 2: 거래량)
  int _selectedIndex = 0;

  // 탭 메뉴 이름들
  final List<String> _tabs = ['🚀 급상승', '💧 급하락', '🔥 거래량'];

  @override
  Widget build(BuildContext context) {
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
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
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

              // 4. 주식 리스트 (5위까지만 표시)
              _buildRankingList(),

              const SizedBox(height: 40), // 하단 여백
            ],
          ),
        ),
      ],
    );
  }

  // 랭킹 리스트 빌더
  Widget _buildRankingList() {
    return Column(
      children: List.generate(5, (index) {
        final rank = index + 1;
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
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
                    const Text(
                      '삼성전자',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '005930',
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
                  const Text(
                    '72,500원',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  // TODO: [병합 시 주의] 현재 등락률 배지 색상과 값은 선택된 탭(_selectedIndex)에 의존하는 모킹 로직입니다.
                  // 실제 데이터 통합 시에는 각 종목 객체의 실제 changeRate 값을 기반으로 색상과 텍스트를 결정하도록 수정해야 합니다. (By CodeRabbit)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _selectedIndex == 1
                          ? const Color(0xFFE3F2FD) // 하락(파란 배경)
                          : const Color(0xFFFFEBEE), // 상승(빨간 배경)
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _selectedIndex == 1 ? '-1.2%' : '+2.5%',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: _selectedIndex == 1
                            ? const Color(0xFF4D96FF) // 파란 글씨
                            : const Color(0xFFFF6B6B), // 빨간 글씨
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
