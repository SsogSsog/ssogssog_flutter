import 'package:flutter/material.dart';
import 'package:ssogssog_flutter/core/theme/app_theme.dart';

/// 범위 값을 조절하는 슬라이더 위젯 (Controlled)
class FilterSlider extends StatelessWidget {
  final String title;
  final String subtitle;
  final double min;
  final double max;
  final double? value; // Parent controls this
  final double step; 
  final String unit; 
  final Widget? headerAction; 
  final Function(double) onChanged;

  const FilterSlider({
    super.key,
    required this.title,
    required this.subtitle,
    required this.min,
    required this.max,
    required this.value,
    required this.onChanged,
    this.step = 1,
    this.unit = '',
    this.headerAction,
  });

  String _valueText() {
    final v = value ?? min;
    if (v <= min) return '전체';
    return '${v.toInt()}$unit 이상';
  }

  @override
  Widget build(BuildContext context) {
    final divisions = step > 0
        ? ((max - min) / step).round().clamp(1, 1000)
        : 1;

    final displayValue = value ?? min;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF8B93A1))),
                  ],
                  if (headerAction != null) ...[
                    const SizedBox(height: 10),
                    headerAction!,
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(_valueText(), style: const TextStyle(fontSize: 14, color: AppColors.primaryBlue, fontWeight: FontWeight.w800)),
            ),
          ],
        ),
        const SizedBox(height: 8),

        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
            overlayShape: SliderComponentShape.noOverlay,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            activeTrackColor: AppColors.primaryBlue,
            inactiveTrackColor: const Color(0xFFE6EAF3),
          ),
          child: Slider(
            value: displayValue,
            min: min,
            max: max,
            divisions: divisions,
            label: displayValue.round().toString(),
            onChanged: (v) {
              final snapped = (v / step).round() * step;
              onChanged(snapped.clamp(min, max));
            },
          ),
        ),
      ],
    );
  }
}
