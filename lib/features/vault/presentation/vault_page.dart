import 'package:flutter/material.dart';
import 'package:ssogssog_flutter/core/widget/common_app_bar.dart';
import 'package:ssogssog_flutter/features/vault/presentation/widget/vault_section_header.dart';
import 'package:ssogssog_flutter/features/vault/presentation/widget/vault_tab_selector.dart';

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
        children: [
          const SizedBox(height: 16),
          VaultTabSelector(
            onTabChanged: (tab) {
              setState(() {
                _selectedTab = tab;
              });
            },
          ),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    // 선택된 탭에 따라 다른 제목과 내용을 가진 리스트를 보여줍니다.
    if (_selectedTab == VaultTab.strategy) {
      return ListView(
        padding: EdgeInsets.zero,
        children: const [
          VaultSectionHeader(
            title: '저장된 전략 리스트 (총 2개)',
            subtitle: '조건식을 저장해두고 언제든 다시 돌려보세요',
          ),
          // TODO: 여기에 StrategyCard 리스트가 들어옵니다.
        ],
      );
    } else {
      return ListView(
        padding: EdgeInsets.zero,
        children: const [
          VaultSectionHeader(
            title: '내가 찜한 주식 (총 2개)',
            subtitle: '관심 종목의 정보를 확인해보세요.',
          ),
          // TODO: 여기에 WatchStockCard 리스트가 들어옵니다.
        ],
      );
    }
  }
}
