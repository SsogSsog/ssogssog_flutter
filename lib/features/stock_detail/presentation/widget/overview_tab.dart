import 'package:flutter/material.dart';
import 'package:ssogssog_flutter/features/stock_detail/data/model/stock_overview_model.dart';
import 'package:ssogssog_flutter/features/stock_detail/presentation/widget/stock_basic_info_card.dart';
import 'package:ssogssog_flutter/features/stock_detail/presentation/widget/stock_chart_card.dart';
import 'package:ssogssog_flutter/features/stock_detail/presentation/widget/stock_company_info_card.dart';
import 'package:ssogssog_flutter/features/stock_detail/presentation/widget/stock_header.dart';

/// 종목 상세 페이지의 '개요' 탭 UI 전체를 담고 있는 위젯
class OverviewTab extends StatelessWidget {
  final StockOverview? overview;

  const OverviewTab({super.key, this.overview});

  @override
  Widget build(BuildContext context) {
    if (overview == null) {
      return const Center(child: Text("데이터를 불러올 수 없습니다."));
    }

    final data = overview!;
    
    // 1. 헤더 데이터 매핑
    final headerData = StockHeaderData(
      name: data.stockName,
      code: data.stockCode,
      currentPrice: data.priceInfo.currentPrice,
      change: data.priceInfo.changeAmount,
      changeRate: data.priceInfo.changeRate,
      volume: data.priceInfo.previousVolume, // API Spec maps previousVolume to this field for display? 
      // User Spec: "currentPrice: DailyPrice.closePrice", "changeAmount...latest vs prev". 
      // Screenshot shows "거래량 2.5M". API PriceInfo has "previousVolume". 
      // Usually current volume is preferred but if not available, previous is ok. 
      // Wait, User API Spec says "previousVolume" in PriceInfo example. 
      // I will use that.
      prevClose: data.priceInfo.previousClose,
      market: data.companyInfo.market,
    );

    // 2. 차트 데이터 매핑
    // API returns priceHistory which is List<ChartHistoryItem> (date, price, volume).
    // StockChartCard expects List<ChartDataPoint> (price, volume).
    // And xTicks.
    final chartHistory = data.chartData.priceHistory;
    final chartDataPoints = chartHistory.map((e) {
      return ChartDataPoint(
        price: (e.price ?? 0).toDouble(), // API price is int?
        volume: (e.volume ?? 0).toDouble(),
      );
    }).toList();

    // X Ticks generation (simple logic: take 5 evenly spaced dates)
    List<String> xTicks = [];
    if (chartHistory.isNotEmpty) {
      final count = 5;
      final step = (chartHistory.length / count).ceil();
      for (int i = 0; i < chartHistory.length; i += step) {
        // Date format "yyyy-MM-dd" -> "MM.dd"
        // Assuming API date is "yyyy-MM-dd"
        final dateStr = chartHistory[i].date;
        if (dateStr.length >= 10) {
            xTicks.add(dateStr.substring(5).replaceAll('-', '.'));
        } else {
            xTicks.add(dateStr);
        }
      }
      // Add last date if not close enough
       if (xTicks.isNotEmpty && chartHistory.last.date.length >= 10) {
           final lastDate = chartHistory.last.date.substring(5).replaceAll('-', '.');
           if (xTicks.last != lastDate) {
               // Replace last or add? Usually replace to show range end.
               xTicks[xTicks.length-1] = lastDate;
           }
       }
    }

    // 3. 기본 정보 데이터 매핑
    final fi = data.financialInfo;
    final basicInfoData = StockBasicInfoData(
      marketCap: _formatEok(fi.marketCap), 
      per: '${fi.per.toStringAsFixed(2)}배',
      roe: '${fi.roe.toStringAsFixed(2)}%',
      dividendYield: fi.dividendYield == 0 ? '-' : '${fi.dividendYield.toStringAsFixed(2)}%',
      week52High: fi.week52Range.high,
      week52Low: fi.week52Range.low,
      currentPrice: data.priceInfo.currentPrice, 
    );

    // 4. 기업 정보 데이터 매핑
    final ci = data.companyInfo;
    final companyInfoData = StockCompanyInfoData(
      sector: ci.sector,
      debtRatio: '${ci.debtRate.toStringAsFixed(2)}%',
      netProfitMargin: '${ci.netProfitMargin.toStringAsFixed(2)}%',
      market: ci.market,
      description: data.companyDescription,
    );

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      children: [
        StockHeader(data: headerData),
        const SizedBox(height: 16),
        StockChartCard(
          chartData: chartDataPoints,
          xTicks: xTicks,
          periodLabel: '지난 3개월 기준', // Updated label
        ),
        const SizedBox(height: 24),
        StockBasicInfoCard(data: basicInfoData),
        const SizedBox(height: 16),
        StockCompanyInfoCard(data: companyInfoData),
      ],
    );
  }

  String _formatEok(int marketCap) {
      if (marketCap == 0) return '-';
      // Assume unit is Won? Or is it 100 million (Eok)?
      // Typical Korea Stock API returns market cap in "Won" (full number) or "million won" or "100 million won".
      // Screenshot says "1,234억".
      // If API returns raw won: 123400000000 -> 1,234억.
      // If API returns million won: 123400 -> 1,234억.
      // Usually strictly raw number.
      // Let's assume raw won for now.
      // 1 억 = 100,000,000 (10^8).
      final eok = marketCap / 100000000;
      return '${_formatInt(eok.round())}억';
  }

  String _formatInt(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
        final posFromEnd = s.length - i;
        buf.write(s[i]);
        if (posFromEnd > 1 && posFromEnd % 3 == 1) buf.write(',');
    }
    return buf.toString();
  }
}
