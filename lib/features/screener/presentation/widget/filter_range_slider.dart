import 'package:flutter/material.dart';
import 'package:ssogssog_flutter/core/theme/app_theme.dart';

/// 양쪽에서 범위 값을 조절하는 슬라이더 위젯
class FilterRangeSlider extends StatefulWidget {
  final String title;
  final String subtitle;
  final double min;
  final double max;
  final Function(RangeValues) onChanged;

  const FilterRangeSlider({
    super.key,
    required this.title,
    required this.subtitle,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  State<FilterRangeSlider> createState() => _FilterRangeSliderState();
}

class _FilterRangeSliderState extends State<FilterRangeSlider> {
  late RangeValues _currentValues;

  @override
  void initState() {
    super.initState();
    // 초기값을 전체 범위로 설정
    _currentValues = RangeValues(widget.min, widget.max);
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
                if (widget.subtitle.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(widget.subtitle, style: const TextStyle(fontSize: 12, color: AppColors.greyText)),
                  ),
              ],
            ),
            // 현재 선택된 범위를 표시
            Text(
              '${_currentValues.start.toInt()} ~ ${_currentValues.end.toInt()}%',
              style: const TextStyle(fontSize: 15, color: AppColors.primaryBlue, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        RangeSlider(
          values: _currentValues,
          min: widget.min,
          max: widget.max,
          divisions: (widget.max - widget.min).toInt(),
          labels: RangeLabels(
            _currentValues.start.round().toString(),
            _currentValues.end.round().toString(),
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _currentValues = values;
            });
            widget.onChanged(values);
          },
        ),
      ],
    );
  }
}
