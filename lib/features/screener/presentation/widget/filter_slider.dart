import 'package:flutter/material.dart';
import 'package:ssogssog_flutter/core/theme/app_theme.dart';

/// 범위 값을 조절하는 슬라이더 위젯
class FilterSlider extends StatefulWidget {
  final String title;
  final String subtitle;
  final double min;
  final double max;
  final double step; // 추가
  final String unit; // 추가
  final Function(double) onChanged;

  const FilterSlider({
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
  State<FilterSlider> createState() => _FilterSliderState();
}

class _FilterSliderState extends State<FilterSlider> {
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.min; // min = 제한 없음(전체)로 취급
  }

  String _valueText() {
    if (_currentValue <= widget.min) return '전체';
    return '${_currentValue.toInt()}${widget.unit} 이상';
  }

  @override
  Widget build(BuildContext context) {
    final divisions = widget.step > 0
        ? ((widget.max - widget.min) / widget.step).round().clamp(1, 1000)
        : 1;

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
            Text(_valueText(), style: const TextStyle(fontSize: 14, color: AppColors.primaryBlue, fontWeight: FontWeight.w800)),
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
            value: _currentValue,
            min: widget.min,
            max: widget.max,
            divisions: divisions,
            label: _currentValue.round().toString(),
            onChanged: (v) {
              final snapped = (v / widget.step).round() * widget.step;
              setState(() => _currentValue = snapped.clamp(widget.min, widget.max));
              widget.onChanged(_currentValue);
            },
          ),
        ),
      ],
    );
  }
}
