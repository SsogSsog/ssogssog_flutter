import 'dart:math';
import 'package:flutter/material.dart';

class PerformanceDataPoint {
  final String period;
  final double revenue;
  final double operatingProfit;
  final double netIncome;

  const PerformanceDataPoint({
    required this.period,
    required this.revenue,
    required this.operatingProfit,
    required this.netIncome,
  });
}

class PerformanceChartCard extends StatefulWidget {
  final List<PerformanceDataPoint> annualData;
  final List<PerformanceDataPoint> quarterlyData;

  const PerformanceChartCard({
    super.key,
    required this.annualData,
    required this.quarterlyData,
  });

  @override
  State<PerformanceChartCard> createState() => _PerformanceChartCardState();
}

class _PerformanceChartCardState extends State<PerformanceChartCard> {
  bool _isAnnual = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = _isAnnual ? widget.annualData : widget.quarterlyData;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withAlpha((0.15 * 255).round())),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 8),
            color: Colors.black.withAlpha((0.06 * 255).round()),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 타이틀 + 토글
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '실적 분석',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              _PillToggle(
                left: '연간',
                right: '분기',
                isLeftSelected: _isAnnual,
                onChanged: (isLeft) => setState(() => _isAnnual = isLeft),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 섹션 1
          _ChartSection(
            title: '매출액',
            subtitle: _isAnnual ? '연간(억원)' : '분기(억원)',
            height: 160,
            painter: _PerformanceChartPainter(
              data: data,
              valueSelector: (d) => d.revenue,
              chartType: _ChartType.bar,
              color: const Color(0xFF58B9CC), // 톤다운 시안
            ),
          ),
          _SoftDivider(),

          // 섹션 2
          _ChartSection(
            title: '영업이익',
            subtitle: _isAnnual ? '연간(억원)' : '분기(억원)',
            height: 160,
            painter: _PerformanceChartPainter(
              data: data,
              valueSelector: (d) => d.operatingProfit,
              chartType: _ChartType.line,
              color: const Color(0xFF66B06A), // 톤다운 그린
            ),
          ),
          _SoftDivider(),

          // 섹션 3
          _ChartSection(
            title: '당기순이익',
            subtitle: _isAnnual ? '연간(억원)' : '분기(억원)',
            height: 160,
            painter: _PerformanceChartPainter(
              data: data,
              valueSelector: (d) => d.netIncome,
              chartType: _ChartType.bar,
              color: const Color(0xFF8098EA), // 톤다운 퍼플/블루
            ),
          ),
        ],
      ),
    );
  }
}

class _SoftDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Divider(
        height: 1,
        thickness: 1,
        color: theme.dividerColor.withAlpha((0.10 * 255).round()),
      ),
    );
  }
}

class _ChartSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final double height;
  final CustomPainter painter;

  const _ChartSection({
    required this.title,
    required this.subtitle,
    required this.height,
    required this.painter,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              subtitle,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.hintColor.withAlpha((0.9 * 255).round()),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: height,
          width: double.infinity,
          child: CustomPaint(
            painter: painter,
          ),
        ),
      ],
    );
  }
}

/// 토글: 목표 UI처럼 pill 느낌 (ToggleButtons보다 덜 투박)
class _PillToggle extends StatelessWidget {
  final String left;
  final String right;
  final bool isLeftSelected;
  final ValueChanged<bool> onChanged;

  const _PillToggle({
    required this.left,
    required this.right,
    required this.isLeftSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 34,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: theme.dividerColor.withAlpha((0.12 * 255).round()),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
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

    return InkWell(
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
            color: selected ? Colors.white : theme.colorScheme.onSurface.withAlpha((0.75 * 255).round()),
          ),
        ),
      ),
    );
  }
}

enum _ChartType { bar, line }

class _PerformanceChartPainter extends CustomPainter {
  final List<PerformanceDataPoint> data;
  final double Function(PerformanceDataPoint) valueSelector;
  final _ChartType chartType;
  final Color color;

  _PerformanceChartPainter({
    required this.data,
    required this.valueSelector,
    required this.chartType,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    const double topPad = 18;
    const double bottomPad = 22;
    const double sidePad = 6;

    final chartRect = Rect.fromLTWH(
      sidePad,
      topPad,
      size.width - sidePad * 2,
      size.height - topPad - bottomPad,
    );

    final rawValues = data.map(valueSelector).toList();
    final isBar = chartType == _ChartType.bar;
    final isLine = chartType == _ChartType.line;

    final plotValues = rawValues.map((v) {
      if (isBar) return v.abs();
      return max(0.0, v);
    }).toList();

    double maxPlot = plotValues.isEmpty ? 1.0 : plotValues.reduce(max);
    if (maxPlot == 0) maxPlot = 1.0;
    maxPlot *= 1.15;

    final baselineY = chartRect.bottom;

    final gridPaint = Paint()
      ..color = Colors.grey.withAlpha((0.10 * 255).round())
      ..strokeWidth = 1;

    for (int i = 1; i <= 2; i++) {
      final y = chartRect.top + chartRect.height * (i / 3);
      canvas.drawLine(
        Offset(chartRect.left, y),
        Offset(chartRect.right, y),
        gridPaint,
      );
    }

    final basePaint = Paint()
      ..color = Colors.grey.withAlpha((0.20 * 255).round())
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset(chartRect.left, baselineY),
      Offset(chartRect.right, baselineY),
      basePaint,
    );

    final stepX = chartRect.width / data.length;
    final barWidth = min(34.0, stepX * 0.55);

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final barPaint = Paint()..color = color;
    final negBarPaint = Paint()..color = Colors.grey.withAlpha((0.35 * 255).round());

    Path? linePath;

    for (int i = 0; i < data.length; i++) {
      final rawV = rawValues[i];
      final plotV = plotValues[i];
      final cx = chartRect.left + stepX * i + stepX / 2;
      final y = baselineY - (plotV / maxPlot) * chartRect.height;

      _drawText(
        canvas,
        data[i].period,
        Offset(cx, baselineY + 10),
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: Colors.black.withAlpha((0.55 * 255).round()),
      );

      final valueLabel = _formatEok(rawV);
      double rawLabelY;
      Color labelColor = Colors.black.withAlpha((0.80 * 255).round());

      // 라벨의 Y좌표를 조정하여 막대/선에 더 가깝게 만듭니다.
      if (isBar) {
        rawLabelY = y - 10; // 기존 -16에서 변경
        if (rawV < 0) {
          labelColor = Colors.black.withAlpha((0.75 * 255).round());
        }
      } else {
        if (rawV >= 0) {
          rawLabelY = y - 10; // 기존 -16에서 변경
        } else {
          rawLabelY = baselineY + 6;
          labelColor = Colors.black.withAlpha((0.70 * 255).round());
        }
      }

      final minLabelY = chartRect.top + 2.0;
      final maxLabelY = chartRect.bottom - 14.0;
      final safeLabelY = rawLabelY.clamp(minLabelY, maxLabelY).toDouble();

      _drawText(
        canvas,
        valueLabel,
        Offset(cx, safeLabelY),
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: labelColor,
      );

      if (isBar) {
        final rect = Rect.fromLTWH(
          cx - barWidth / 2,
          y,
          barWidth,
          (baselineY - y).clamp(0.0, chartRect.height),
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(6)),
          rawV >= 0 ? barPaint : negBarPaint,
        );
      } else {
        if (i == 0) {
          linePath = Path()..moveTo(cx, y);
        } else {
          final prevPlotV = plotValues[i - 1];
          final prevCx = chartRect.left + stepX * (i - 1) + stepX / 2;
          final prevY = baselineY - (prevPlotV / maxPlot) * chartRect.height;
          final midX = (prevCx + cx) / 2;
          linePath!.quadraticBezierTo(prevCx, prevY, midX, (prevY + y) / 2);
          linePath.quadraticBezierTo(cx, y, cx, y);
        }
      }
    }

    if (isLine && linePath != null) {
      final fillPath = Path.from(linePath);
      fillPath.lineTo(chartRect.right, baselineY);
      fillPath.lineTo(chartRect.left, baselineY);
      fillPath.close();

      final fillPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withAlpha((255 * 0.22).round()), color.withAlpha(0)],
        ).createShader(chartRect);

      canvas.drawPath(fillPath, fillPaint);
      canvas.drawPath(linePath, linePaint);
    }
  }

  String _formatEok(double v) {
    final n = v.round();
    return '${_formatInt(n)}억';
  }

  String _formatInt(int n) {
    final neg = n < 0;
    final absStr = n.abs().toString();
    final buf = StringBuffer();

    for (int i = 0; i < absStr.length; i++) {
      final posFromEnd = absStr.length - i;
      buf.write(absStr[i]);
      if (posFromEnd > 1 && posFromEnd % 3 == 1) buf.write(',');
    }
    return neg ? '-${buf.toString()}' : buf.toString();
  }

  void _drawText(
      Canvas canvas,
      String text,
      Offset center, {
        required double fontSize,
        required FontWeight fontWeight,
        required Color color,
      }) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: color)),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: 60);

    textPainter.paint(canvas, center - Offset(textPainter.width / 2, textPainter.height / 2));
  }

  @override
  bool shouldRepaint(covariant _PerformanceChartPainter oldDelegate) {
    return true;
  }
}
