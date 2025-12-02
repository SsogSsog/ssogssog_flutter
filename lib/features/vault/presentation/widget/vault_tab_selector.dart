import 'package:flutter/material.dart';
import 'package:ssogssog_flutter/core/theme/app_theme.dart';

enum VaultTab { strategy, watchlist }

class VaultTabSelector extends StatefulWidget {
  final Function(VaultTab) onTabChanged;

  const VaultTabSelector({super.key, required this.onTabChanged});

  @override
  State<VaultTabSelector> createState() => _VaultTabSelectorState();
}

class _VaultTabSelectorState extends State<VaultTabSelector> {
  VaultTab _selectedTab = VaultTab.strategy;

  void _selectTab(VaultTab tab) {
    if (_selectedTab != tab) {
      setState(() {
        _selectedTab = tab;
      });
      widget.onTabChanged(tab);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(30), // 더 둥글게
        ),
        child: Row(
          children: [
            _buildTab(VaultTab.strategy, '나의 전략', Icons.folder),
            _buildTab(VaultTab.watchlist, '관심 종목', Icons.favorite),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(VaultTab tab, String text, IconData icon) {
    final bool isSelected = _selectedTab == tab;
    return Expanded(
      child: GestureDetector(
        onTap: () => _selectTab(tab),
        // 투명한 배경을 추가하여 GestureDetector의 기본 히트 테스트 동작을 보장
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                // [수정] 선택 시 흰색, 미선택 시 회색
                color: isSelected ? Colors.white : AppColors.greyText,
                size: 18, // 아이콘 크기 살짝 조정
              ),
              const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  // [수정] 선택 시 흰색, 미선택 시 회색
                  color: isSelected ? Colors.white : AppColors.greyText,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
