import 'package:flutter/material.dart';

/// 토글: 목표 UI처럼 pill 느낌 (ToggleButtons보다 덜 투박)
class PillToggle extends StatelessWidget {
  final String left;
  final String right;
  final bool isLeftSelected;
  final ValueChanged<bool> onChanged;

  const PillToggle({
    super.key,
    required this.left,
    required this.right,
    required this.isLeftSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.dividerColor.withAlpha((0.12 * 255).round()),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 34,
        padding: const EdgeInsets.all(3),
        child: Row(
          mainAxisSize: MainAxisSize.min, // Row가 필요한 만큼만 공간을 차지하도록 설정
          children: [
            _PillItem(
              text: left,
              selected: isLeftSelected,
              onTap: () => onChanged(true),
            ),
            _PillItem(
              text: right,
              selected: !isLeftSelected,
              onTap: () => onChanged(false),
            ),
          ],
        ),
      ),
    );
  }
}

class _PillItem extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _PillItem({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // CodeRabbit Review 반영: InkWell을 Material로 감싸야 함
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF3B82F6) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            text,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: selected
                  ? Colors.white
                  : theme.colorScheme.onSurface.withAlpha((0.75 * 255).round()),
            ),
          ),
        ),
      ),
    );
  }
}
