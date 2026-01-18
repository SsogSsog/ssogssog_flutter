import 'package:flutter/material.dart';
import 'package:ssogssog_flutter/core/theme/app_theme.dart';

class FilterChipGroup extends StatelessWidget {
  final String title;
  final List<String> options;
  final String? selectedOption; // Control from parent
  final Function(String?) onSelected;
  final int columns;

  const FilterChipGroup({
    super.key,
    required this.title,
    required this.options,
    required this.selectedOption,
    required this.onSelected,
    this.columns = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),

        LayoutBuilder(
          builder: (context, c) {
            const spacing = 10.0;
            const runSpacing = 10.0;

            Widget chipFor(String option, double? fixedWidth) {
              final isSelected = selectedOption == option;

              final chip = ChoiceChip(
                label: Text(option, textAlign: TextAlign.center),
                selected: isSelected,
                onSelected: (selected) {
                  onSelected(selected ? option : null);
                },
                showCheckmark: false,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                labelStyle: TextStyle(
                  fontSize: 13,
                  color: isSelected ? Colors.white : const Color(0xFF3A3A3A),
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                ),
                backgroundColor: const Color(0xFFF0F3FA),
                selectedColor: AppColors.primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(color: isSelected ? Colors.transparent : const Color(0xFFE2E7F2)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              );

              if (fixedWidth == null) return chip;
              return SizedBox(width: fixedWidth, child: Center(child: chip));
            }

            if (columns <= 0) {
              return Wrap(
                spacing: spacing,
                runSpacing: runSpacing,
                children: options.map((o) => chipFor(o, null)).toList(),
              );
            }

            final w = (c.maxWidth - spacing * (columns - 1)) / columns;

            return Wrap(
              spacing: spacing,
              runSpacing: runSpacing,
              children: options.map((o) => chipFor(o, w)).toList(),
            );
          },
        ),
      ],
    );
  }
}
