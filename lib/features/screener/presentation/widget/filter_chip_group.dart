import 'package:flutter/material.dart';
import 'package:ssogssog_flutter/core/theme/app_theme.dart';

/// 여러 선택지 중 하나를 고르는 칩 그룹 위젯
class FilterChipGroup extends StatefulWidget {
  final String title;
  final List<String> options;
  final Function(String?) onSelected;

  const FilterChipGroup({
    super.key,
    required this.title,
    required this.options,
    required this.onSelected,
  });

  @override
  State<FilterChipGroup> createState() => _FilterChipGroupState();
}

class _FilterChipGroupState extends State<FilterChipGroup> {
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8.0, // 칩 사이의 가로 간격
          runSpacing: 8.0, // 칩 사이의 세로 간격
          children: widget.options.map((option) {
            final isSelected = _selectedOption == option;
            return ChoiceChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedOption = selected ? option : null;
                });
                widget.onSelected(_selectedOption);
              },
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.primaryBlue,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              backgroundColor: AppColors.lightBlueBackground,
              selectedColor: AppColors.primaryBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Colors.transparent),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            );
          }).toList(),
        ),
      ],
    );
  }
}
