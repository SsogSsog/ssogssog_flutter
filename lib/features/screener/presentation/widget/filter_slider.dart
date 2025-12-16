import 'package:flutter/material.dart';
import 'package:ssogssog_flutter/core/theme/app_theme.dart';

/// 범위 값을 조절하는 슬라이더 위젯
class FilterSlider extends StatefulWidget {
  final String title;
  final String subtitle;
  final double min;
  final double max;
  final Function(double) onChanged;

  const FilterSlider({
    super.key,
    required this.title,
    required this.subtitle,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  State<FilterSlider> createState() => _FilterSliderState();
}

class _FilterSliderState extends State<FilterSlider> {
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.min; // 초기값을 최소값으로 설정
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(widget.subtitle, style: const TextStyle(fontSize: 12, color: AppColors.greyText)),
              ],
            ),
            // 현재 선택된 값을 표시
            Text(
              '${_currentValue.toInt()} 이상', 
              style: const TextStyle(fontSize: 15, color: AppColors.primaryBlue, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          value: _currentValue,
          min: widget.min,
          max: widget.max,
          divisions: (widget.max - widget.min).toInt(), // 눈금 개수
          label: _currentValue.round().toString(),
          onChanged: (double value) {
            setState(() {
              _currentValue = value;
            });
            widget.onChanged(value);
          },
        ),
      ],
    );
  }
}
