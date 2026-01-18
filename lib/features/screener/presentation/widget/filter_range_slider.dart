import 'package:flutter/material.dart';
import 'package:ssogssog_flutter/core/theme/app_theme.dart';

/// 양쪽에서 범위 값을 조절하는 슬라이더 위젯 (Controlled)
class FilterRangeSlider extends StatelessWidget {
  final String title;
  final String subtitle;
  final double min;
  final double max;
  final RangeValues? values; // Parent controls this
  final double step;
  final String unit;
  final Widget? headerAction;
  final Function(RangeValues) onChanged;

  const FilterRangeSlider({
    super.key,
    required this.title,
    required this.subtitle,
    required this.min,
    required this.max,
    required this.values,
    required this.onChanged,
    this.step = 1,
    this.unit = '',
    this.headerAction,
  });

  String _rangeText() {
    final v = values ?? RangeValues(min, max);
    final isAll = v.start <= min && v.end >= max;
    if (isAll) return '전체';
    return '${v.start.toInt()} ~ ${v.end.toInt()}$unit';
  }

  @override
  Widget build(BuildContext context) {
    final divisions = step > 0
        ? ((max - min) / step).round().clamp(1, 1000)
        : 1;
    
    final displayValues = values ?? RangeValues(min, max);

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
              child: Text(_rangeText(), style: const TextStyle(fontSize: 14, color: AppColors.primaryBlue, fontWeight: FontWeight.w800)),
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
          child: RangeSlider(
            values: displayValues,
            min: min,
            max: max,
            divisions: divisions,
            labels: RangeLabels(
              displayValues.start.round().toString(),
              displayValues.end.round().toString(),
            ),
            onChanged: (v) {
              double snap(double x) => (x / step).round() * step;
              final next = RangeValues(snap(v.start), snap(v.end));
              onChanged(RangeValues(
                next.start.clamp(min, max),
                next.end.clamp(min, max),
              ));
            },
          ),
        ),
      ],
    );
  }
}
