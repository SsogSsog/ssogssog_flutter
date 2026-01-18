import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ssogssog_flutter/core/widget/common_app_bar.dart';
import 'package:ssogssog_flutter/features/vault/data/model/strategy_models.dart';
import 'package:ssogssog_flutter/features/vault/data/repository/strategy_repository.dart';
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

  final StrategyRepository _repository = StrategyRepository();
  List<Strategy> _strategies = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchStrategies();
  }

  Future<void> _fetchStrategies() async {
    setState(() => _isLoading = true);
    final list = await _repository.getStrategies();
    if (mounted) {
      setState(() {
        _strategies = list;
        _isLoading = false;
      });
    }
  }

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
            VaultSectionHeader(
              title: '저장된 전략 리스트 (총 ${_strategies.length}개)',
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
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_selectedTab == VaultTab.strategy) {
      if (_strategies.isEmpty) {
        return _buildEmptyStrategyView();
      }
      
      return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: _strategies.length + 1, // 리스트 + 추가 버튼
        itemBuilder: (context, index) {
          if (index == _strategies.length) {
            return _buildAddButton();
          }
          return StrategyCard(
            strategy: _strategies[index],
            onDelete: () => _onDeleteStrategy(_strategies[index]),
          );
        },
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

  Widget _buildEmptyStrategyView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          '저장된 전략이 없습니다.',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
        const SizedBox(height: 20),
        _buildAddButton(),
      ],
    );
  }

  Widget _buildAddButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: OutlinedButton(
        onPressed: () {
          context.push('/screener'); // 스크리너 페이지로 이동
        },
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
          backgroundColor: const Color(0xFFF8F9FA),
          side: BorderSide(color: Colors.grey[300]!, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
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
    );
  }

  void _onDeleteStrategy(Strategy strategy) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('전략 삭제', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text("'${strategy.strategyName}' 전략을 삭제하시겠습니까?\n삭제된 전략은 복구할 수 없습니다."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            style: TextButton.styleFrom(foregroundColor: Colors.grey),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx); // 다이얼로그 닫기
              
              final success = await _repository.deleteStrategy(strategy.strategyId);
              if (mounted) {
                if (success) {
                  _fetchStrategies(); // 목록 갱신
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('전략이 삭제되었습니다.')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('삭제에 실패했습니다. 다시 시도해주세요.')),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: const Color(0xFFE53935)),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }
}
