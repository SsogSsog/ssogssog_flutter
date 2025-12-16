import 'package:flutter/material.dart';
import 'package:ssogssog_flutter/core/theme/app_theme.dart';

/// 양쪽에서 범위 값을 조절하는 슬라이더 위젯
class FilterRangeSlider extends StatefulWidget {
  final String title;
  final String subtitle;
  final double min;
  final double max;
  final double step;
  final String unit;
  final Function(RangeValues) onChanged;

  const FilterRangeSlider({
    super.key,
    required this.title,
    required this.subtitle,
    required this.min,
    required this.max,
    required this.onChanged,
    this.step = 1,
    this.unit = '',
  });

  @override
  State<FilterRangeSlider> createState() => _FilterRangeSliderState();
}

class _FilterRangeSliderState extends State<FilterRangeSlider> {
  late RangeValues _currentValues;

  @override
  void initState() {
    super.initState();
    _currentValues = RangeValues(widget.min, widget.max); // 전체
  }

  String _rangeText() {
    final isAll = _currentValues.start <= widget.min && _currentValues.end >= widget.max;
    if (isAll) return '전체';
    return '${_currentValues.start.toInt()} ~ ${_currentValues.end.toInt()}${widget.unit}';
  }

  @override
  Widget build(BuildContext context) {
    final divisions = ((widget.max - widget.min) / widget.step).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                  if (widget.subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(widget.subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF8B93A1))),
                  ],
                ],
              ),
            ),
            Text(_rangeText(), style: const TextStyle(fontSize: 14, color: AppColors.primaryBlue, fontWeight: FontWeight.w800)),
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
            values: _currentValues,
            min: widget.min,
            max: widget.max,
            divisions: divisions,
            labels: RangeLabels(
              _currentValues.start.round().toString(),
              _currentValues.end.round().toString(),
            ),
            onChanged: (v) {
              double snap(double x) => (x / widget.step).round() * widget.step;
              final next = RangeValues(snap(v.start), snap(v.end));
              setState(() => _currentValues = RangeValues(
                next.start.clamp(widget.min, widget.max),
                next.end.clamp(widget.min, widget.max),
              ));
              widget.onChanged(_currentValues);
            },
          ),
        ),
      ],
    );
  }
}
