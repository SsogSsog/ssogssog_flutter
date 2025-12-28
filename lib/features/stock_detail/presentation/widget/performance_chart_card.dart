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
        border: Border.all(color: theme.dividerColor.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 8),
            color: Colors.black.withOpacity(0.06),
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
              Text(
                '실적 분석',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
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
              color: const Color(0xFF8098EA), // 톤다운 오렌지
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
        color: theme.dividerColor.withOpacity(0.10),
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
                color: theme.hintColor.withOpacity(0.9),
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
        color: theme.dividerColor.withOpacity(0.12),
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
            color: selected ? Colors.white : theme.colorScheme.onSurface.withOpacity(0.75),
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

    // 차트 내부 패딩(라벨/축 때문에 필수)
    const double topPad = 18;    // 값 라벨 공간
    const double bottomPad = 22; // 기간 라벨 공간
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

    // ============================================================
    // 요구사항 반영 스케일/플로팅 값
    // 1) Bar: 음수여도 위로만(절댓값으로 높이 계산), 색만 회색
    // 2) Line(영업이익): 음수면 0으로 클램프해서 아래로 내려가지 않게
    // ============================================================
    final plotValues = rawValues.map((v) {
      if (isBar) return v.abs();         // bar는 절댓값으로 높이 계산
      return max(0.0, v);               // line은 음수면 0으로 클램프
    }).toList();

    double maxPlot = plotValues.isEmpty ? 1.0 : plotValues.reduce(max);
    if (maxPlot == 0) maxPlot = 1.0;
    maxPlot *= 1.15; // 약간 여유

    final baselineY = chartRect.bottom; // 항상 아래가 기준선(위로만 그림)

    // 은은한 보조 그리드(2줄)
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.10)
      ..strokeWidth = 1;

    for (int i = 1; i <= 2; i++) {
      final y = chartRect.top + chartRect.height * (i / 3);
      canvas.drawLine(
        Offset(chartRect.left, y),
        Offset(chartRect.right, y),
        gridPaint,
      );
    }

    // 기준선(하단)
    final basePaint = Paint()
      ..color = Colors.grey.withOpacity(0.20)
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
    final negBarPaint = Paint()..color = Colors.grey.withOpacity(0.35);

    Path? linePath;

    for (int i = 0; i < data.length; i++) {
      final rawV = rawValues[i];     // 라벨은 원래 값(음수면 - 표시)
      final plotV = plotValues[i];   // 그릴 때만 변환(절댓값/클램프)

      final cx = chartRect.left + stepX * i + stepX / 2;

      // plotV는 [0..maxPlot] 범위라고 가정
      final y = baselineY - (plotV / maxPlot) * chartRect.height;

      // 기간 라벨
      _drawText(
        canvas,
        data[i].period,
        Offset(cx, size.height - bottomPad + 4),
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: Colors.black.withOpacity(0.55),
      );

      // 값 라벨
      final valueLabel = _formatEok(rawV);

      double rawLabelY;
      Color labelColor = Colors.black.withOpacity(0.80);

      if (isBar) {
        // bar는 항상 막대 위쪽에 라벨
        rawLabelY = y - 16;
        if (rawV < 0) {
          // 적자 표시(요구사항: 숫자에 - 붙여 표시) -> 이미 valueLabel이 - 포함
          // 라벨 색은 그대로 두거나 약간 톤다운해도 됨(원하면 아래처럼)
          labelColor = Colors.black.withOpacity(0.75);
        }
      } else {
        // line: 음수면 선은 baseline에 붙지만 라벨은 아래로 살짝 내려서(적자 느낌)
        if (rawV >= 0) {
          rawLabelY = y - 16;
        } else {
          rawLabelY = baselineY + 6;
          labelColor = Colors.black.withOpacity(0.70);
        }
      }

      // 침범 방지 clamp (⚠️ clamp는 num 반환 -> toDouble 필수)
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
        // bar: 음수도 위로만 그리기(절댓값 plotV로 y 계산했기 때문에 자연스럽게 위로)
        final rect = Rect.fromLTWH(
          cx - barWidth / 2,
          y,
          barWidth,
          (baselineY - y).clamp(0.0, chartRect.height),
        );

        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(6)),
          rawV >= 0 ? barPaint : negBarPaint, // ✅ 음수면 회색
        );
      } else {
        // line: 음수는 0으로 클램프되어 y가 baseline에 붙음
        if (i == 0) {
          linePath = Path()..moveTo(cx, y);
        } else {
          final prevPlotV = plotValues[i - 1];
          final prevCx = chartRect.left + stepX * (i - 1) + stepX / 2;
          final prevY = baselineY - (prevPlotV / maxPlot) * chartRect.height;

          // 간단 스무딩
          final midX = (prevCx + cx) / 2;
          linePath!.quadraticBezierTo(prevCx, prevY, midX, (prevY + y) / 2);
          linePath!.quadraticBezierTo(cx, y, cx, y);
        }
      }
    }

    // line fill (baseline까지)
    if (isLine && linePath != null) {
      final fillPath = Path.from(linePath!);
      fillPath.lineTo(chartRect.right, baselineY);
      fillPath.lineTo(chartRect.left, baselineY);
      fillPath.close();

      final fillPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withOpacity(0.22), color.withOpacity(0.0)],
        ).createShader(chartRect);

      canvas.drawPath(fillPath, fillPaint);
      canvas.drawPath(linePath!, linePaint);
    }
  }

  String _formatEok(double v) {
    final n = v.round(); // 음수면 - 유지
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
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout();

    tp.paint(canvas, Offset(center.dx - tp.width / 2, center.dy));
  }

  @override
  bool shouldRepaint(covariant _PerformanceChartPainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.chartType != chartType ||
        oldDelegate.color != color;
  }
}
