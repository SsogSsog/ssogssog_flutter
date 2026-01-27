import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    // 2. 차트 데이터 매핑
    final priceHistory = data.chartData.priceHistory;
    final volumeHistory = data.chartData.volumeHistory;
    
    // Create a map for quick lookup of volume by date
    final volumeMap = {
      for (var item in volumeHistory) item.date: item.volume ?? 0,
    };

    final chartDataPoints = priceHistory.map((e) {
      final vol = volumeMap[e.date] ?? 0;
      return ChartDataPoint(
        price: (e.price ?? 0).toDouble(),
        volume: vol.toDouble(),
      );
    }).toList();

    // X Ticks generation (simple logic: take 5 evenly spaced dates)
    List<String> xTicks = [];
    if (priceHistory.isNotEmpty) {
      final count = 5;
      final step = (priceHistory.length / count).ceil();
      for (int i = 0; i < priceHistory.length; i += step) {
        // Date format "yyyy-MM-dd" -> "MM.dd"
        // Assuming API date is "yyyy-MM-dd"
        final dateStr = priceHistory[i].date;
        if (dateStr.length >= 10) {
            xTicks.add(dateStr.substring(5).replaceAll('-', '.'));
        } else {
            xTicks.add(dateStr);
        }
      }
      // Add last date if not close enough
       if (xTicks.isNotEmpty && priceHistory.last.date.length >= 10) {
           final lastDate = priceHistory.last.date.substring(5).replaceAll('-', '.');
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
      // API returns marketCap in units of 100 Million (Eok)
      return '${_formatInt(marketCap)}억';
  }

  String _formatInt(int n) {
    return NumberFormat('#,###').format(n);
  }
}
