import 'dart:math';
import 'package:flutter/material.dart';

class ChartDataPoint {
  final double price;
  final double volume;

  ChartDataPoint({required this.price, required this.volume});
}

class StockChartCard extends StatelessWidget {
  final List<ChartDataPoint> chartData;
  final List<String>? xTicks;
  final String periodLabel;
  final bool showRightAxisLabels;
  final bool showSummaryLegend;

  const StockChartCard({
    super.key,
    required this.chartData,
    this.xTicks,
    this.periodLabel = '지난 6개월 기준',
    this.showRightAxisLabels = true,
    this.showSummaryLegend = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final summary = chartData.isEmpty
        ? null
        : _ChartSummary(
            maxPrice: chartData.map((e) => e.price).reduce(max),
            minPrice: chartData.map((e) => e.price).reduce(min),
            maxVolume: chartData.map((e) => e.volume).reduce(max),
          );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: DecoratedBox(
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RepaintBoundary(
                child: SizedBox(
                  height: 250,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CustomPaint(
                      painter: _StockChartPainter(
                        data: chartData,
                        theme: theme,
                        xTicks: xTicks,
                        showRightAxisLabels: showRightAxisLabels,
                      ),
                    ),
                  ),
                ),
              ),
              if (showSummaryLegend && summary != null) ...[
                const SizedBox(height: 10),
                _SummaryLegend(summary: summary),
              ],
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  periodLabel,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.hintColor.withAlpha((0.9 * 255).round()),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChartSummary {
  final double maxPrice;
  final double minPrice;
  final double maxVolume;

  const _ChartSummary({
    required this.maxPrice,
    required this.minPrice,
    required this.maxVolume,
  });
}

class _SummaryLegend extends StatelessWidget {
  final _ChartSummary summary;
  const _SummaryLegend({required this.summary});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget chip(String label, String value) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withAlpha((0.6 * 255).round()),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: theme.dividerColor.withAlpha((0.15 * 255).round())),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.hintColor.withAlpha((0.95 * 255).round()),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              value,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha((0.85 * 255).round()),
              ),
            ),
          ],
        ),
      );
    }

    final maxPriceText = _formatIntWithComma(summary.maxPrice.round());
    final minPriceText = _formatIntWithComma(summary.minPrice.round());
    final maxVolText = _formatVolume(summary.maxVolume);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.start,
      children: [
        chip('최고가', maxPriceText),
        chip('최저가', minPriceText),
        chip('최대 거래량', maxVolText),
      ],
    );
  }

  String _formatIntWithComma(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final posFromEnd = s.length - i;
      buf.write(s[i]);
      if (posFromEnd > 1 && posFromEnd % 3 == 1) buf.write(',');
    }
    return buf.toString();
  }

  String _formatVolume(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}K';
    return v.toStringAsFixed(0);
  }
}

class _StockChartPainter extends CustomPainter {
  final List<ChartDataPoint> data;
  final ThemeData theme;
  final List<String>? xTicks;
  final bool showRightAxisLabels;

  _StockChartPainter({
    required this.data,
    required this.theme,
    required this.xTicks,
    required this.showRightAxisLabels,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;

    const padLeft = 10.0;
    const padTop = 12.0;
    const padBottom = 22.0;
    const padRight = 50.0; // Increased padding for formatted labels

    final fullRect = Offset.zero & size;
    final plotRect = Rect.fromLTWH(
      padLeft,
      padTop,
      size.width - padLeft - padRight,
      size.height - padTop - padBottom,
    );

    final priceRect = Rect.fromLTWH(
      plotRect.left,
      plotRect.top,
      plotRect.width,
      plotRect.height * 0.72,
    );
    final volumeRect = Rect.fromLTWH(
      plotRect.left,
      priceRect.bottom + plotRect.height * 0.04,
      plotRect.width,
      plotRect.height * 0.24,
    );

    final prices = data.map((e) => e.price).toList();
    final volumes = data.map((e) => e.volume).toList();

    double maxPrice = prices.reduce(max);
    double minPrice = prices.reduce(min);
    final maxVolume = volumes.reduce(max);

    if ((maxPrice - minPrice).abs() < 1e-9) {
      maxPrice += 1;
      minPrice -= 1;
    }

    final priceRange = maxPrice - minPrice;
    maxPrice += priceRange * 0.06;
    minPrice -= priceRange * 0.06;

    final gridPaint = Paint()
      ..color = theme.dividerColor.withAlpha((0.10 * 255).round())
      ..strokeWidth = 1;

    final linePaint = Paint()
      ..color = theme.colorScheme.onSurface.withAlpha((0.55 * 255).round())
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    final barPaint = Paint()
      ..color = Colors.blueAccent.withAlpha((0.55 * 255).round())
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final labelStyle = theme.textTheme.labelSmall?.copyWith(
      color: theme.hintColor.withAlpha((0.9 * 255).round()),
      fontSize: 11,
    );

    canvas.drawRect(
      fullRect,
      Paint()..color = theme.scaffoldBackgroundColor.withAlpha((0.02 * 255).round()),
    );

    const gridLines = 4;
    for (int i = 0; i <= gridLines; i++) {
      final y = priceRect.top + (priceRect.height / gridLines) * i;
      canvas.drawLine(Offset(priceRect.left, y), Offset(priceRect.right, y), gridPaint);
    }

    final stepX = priceRect.width / (data.length - 1);

    double priceToY(double p) {
      final t = (p - minPrice) / (maxPrice - minPrice);
      return priceRect.bottom - t * priceRect.height;
    }

    double volumeToH(double v) {
      if (maxVolume <= 0) return 0;
      final t = (v / maxVolume).clamp(0.0, 1.0);
      return t * volumeRect.height;
    }

    final points = <Offset>[];
    for (int i = 0; i < data.length; i++) {
      final x = priceRect.left + stepX * i;
      final y = priceToY(data[i].price);
      points.add(Offset(x, y));
    }

    final barW = (stepX * 0.55).clamp(2.5, 7.0);
    for (int i = 0; i < data.length; i++) {
      final x = volumeRect.left + stepX * i;
      final h = volumeToH(data[i].volume);
      final r = Rect.fromLTWH(
        x - barW / 2,
        volumeRect.bottom - h,
        barW,
        h,
      );
      final rr = RRect.fromRectAndRadius(r, const Radius.circular(2.5));
      canvas.drawRRect(rr, barPaint);
    }

    canvas.drawLine(
      Offset(volumeRect.left, volumeRect.bottom),
      Offset(volumeRect.right, volumeRect.bottom),
      gridPaint,
    );

    final smoothPath = _catmullRomToBezier(points);

    final fillPath = Path.from(smoothPath)
      ..lineTo(points.last.dx, priceRect.bottom)
      ..lineTo(points.first.dx, priceRect.bottom)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          theme.colorScheme.onSurface.withAlpha((0.10 * 255).round()),
          theme.colorScheme.onSurface.withAlpha(0),
        ],
      ).createShader(priceRect);

    canvas.drawPath(fillPath, fillPaint);

    canvas.drawPath(smoothPath, linePaint);

    if (showRightAxisLabels) {
      _drawRightLabel(
        canvas,
        text: _formatIntWithComma(maxPrice.round()), // Formatting Added
        x: plotRect.right + 6,
        y: priceRect.top - 2,
        style: labelStyle,
      );
      _drawRightLabel(
        canvas,
        text: _formatIntWithComma(minPrice.round()), // Formatting Added
        x: plotRect.right + 6,
        y: priceRect.bottom - 12,
        style: labelStyle,
      );
      
      // Removed the 0 label for Volume to clean up UI
      // _drawRightLabel(
      //   canvas,
      //   text: '0', 
      //   x: plotRect.right + 6,
      //   y: volumeRect.bottom - 6,
      //   style: labelStyle,
      // );
      
      // Only show Max Volume
      _drawRightLabel(
        canvas,
        text: _formatVolume(maxVolume),
        x: plotRect.right + 6,
        y: volumeRect.top - 2,
        style: labelStyle,
      );
    }

    if (xTicks != null && xTicks!.isNotEmpty) {
      _drawXTicks(canvas, plotRect, xTicks!, labelStyle);
    }
  }

  Path _catmullRomToBezier(List<Offset> pts, {double tension = 0.2}) {
    final p = pts;
    final path = Path()..moveTo(p[0].dx, p[0].dy);

    for (int i = 0; i < p.length - 1; i++) {
      final p0 = i == 0 ? p[i] : p[i - 1];
      final p1 = p[i];
      final p2 = p[i + 1];
      final p3 = (i + 2 < p.length) ? p[i + 2] : p2;

      final c1 = Offset(
        p1.dx + (p2.dx - p0.dx) * tension,
        p1.dy + (p2.dy - p0.dy) * tension,
      );
      final c2 = Offset(
        p2.dx - (p3.dx - p1.dx) * tension,
        p2.dy - (p3.dy - p1.dy) * tension,
      );

      path.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, p2.dx, p2.dy);
    }
    return path;
  }

  void _drawRightLabel(
      Canvas canvas, {
        required String text,
        required double x,
        required double y,
        required TextStyle? style,
      }) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();

    tp.paint(canvas, Offset(x, y));
  }

  void _drawXTicks(Canvas canvas, Rect plotRect, List<String> ticks, TextStyle? style) {
    final count = ticks.length;
    if (count < 2) return;

    final tpList = ticks
        .map((t) => TextPainter(
              text: TextSpan(text: t, style: style),
              textDirection: TextDirection.ltr,
            )..layout())
        .toList();

    for (int i = 0; i < count; i++) {
      final t = i / (count - 1);
      final x = plotRect.left + plotRect.width * t;
      final tp = tpList[i];

      double dx = x - tp.width / 2;
      dx = dx.clamp(plotRect.left, plotRect.right - tp.width);

      tp.paint(canvas, Offset(dx, plotRect.bottom + 4));
    }
  }

  String _formatNumber(double v) {
    final n = v.round();
    return n.toString();
  }
  
  String _formatIntWithComma(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final posFromEnd = s.length - i;
      buf.write(s[i]);
      if (posFromEnd > 1 && posFromEnd % 3 == 1) buf.write(',');
    }
    return buf.toString();
  }

  String _formatVolume(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}K';
    return v.toStringAsFixed(0);
  }

  @override
  bool shouldRepaint(covariant _StockChartPainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.theme != theme ||
        oldDelegate.xTicks != xTicks;
  }
}
