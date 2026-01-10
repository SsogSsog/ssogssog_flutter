import 'package:flutter/material.dart';
import 'package:ssogssog_flutter/core/widget/common_app_bar.dart';
import 'package:ssogssog_flutter/features/vault/presentation/widget/strategy_card.dart';
import 'package:ssogssog_flutter/features/vault/presentation/widget/vault_section_header.dart';
import 'package:ssogssog_flutter/features/vault/presentation/widget/vault_tab_selector.dart';
import 'package:ssogssog_flutter/features/vault/presentation/widget/watch_stock_card.dart';

class VaultPage extends StatefulWidget {
  const VaultPage({super.key});

  @override
  State<VaultPage> createState() => _VaultPageState();
}

class _VaultPageState extends State<VaultPage> {
  VaultTab _selectedTab = VaultTab.strategy;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: '내 보관함'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          VaultTabSelector(
            onTabChanged: (tab) {
              setState(() {
                _selectedTab = tab;
              });
            },
          ),

          if (_selectedTab == VaultTab.strategy)
            const VaultSectionHeader(
              title: '저장된 전략 리스트 (총 2개)',
              subtitle: '조건식을 저장해두고 언제든 다시 돌려보세요',
            )
          else
            const VaultSectionHeader(
              title: '내가 찜한 주식 (총 2개)',
              subtitle: '관심 종목의 정보를 확인해보세요.',
            ),
          
          Expanded(
            child: _buildCardList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCardList() {
    if (_selectedTab == VaultTab.strategy) {
      return ListView(
        padding: EdgeInsets.zero,
        children: [
          StrategyCard(),
          StrategyCard(),
          // 새로운 전략 만들기 버튼
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: OutlinedButton(
              onPressed: () {

              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                backgroundColor: const Color(0xFFF8F9FA), // 아주 연한 회색 배경
                side: BorderSide(color: Colors.grey[300]!, width: 1.5), // 회색 테두리
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16), // 카드와 같은 둥글기
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_rounded, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    '새로운 전략 만들기',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      return ListView(
        padding: EdgeInsets.zero,
        children: const [
          WatchStockCard(stockName: '삼성전자', stockCode: '005930', price: '72,500원', sector: '반도체', fluctuationRate: '+2.5%',),
          WatchStockCard(stockName: 'LG에너지솔루션', stockCode: '373220', price: '410,000원', sector: '2차전지', fluctuationRate: '-1.5%',)
        ],
      );
    }
  }
}
