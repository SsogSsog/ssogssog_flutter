import 'package:flutter/material.dart';
import 'package:ssogssog_flutter/features/stock_detail/data/model/stock_overview_model.dart';
import 'package:ssogssog_flutter/features/stock_detail/data/repository/stock_detail_repository.dart';
import 'package:ssogssog_flutter/features/stock_detail/presentation/widget/daily_price_tab.dart';
import 'package:ssogssog_flutter/features/stock_detail/presentation/widget/financials_tab.dart';
import 'package:ssogssog_flutter/features/stock_detail/presentation/widget/overview_tab.dart';
import 'package:ssogssog_flutter/features/stock_detail/presentation/widget/news_announcements_tab.dart';

class StockDetailPage extends StatefulWidget {
  final String stockCode;

  const StockDetailPage({super.key, required this.stockCode});

  @override
  State<StockDetailPage> createState() => _StockDetailPageState();
}

class _StockDetailPageState extends State<StockDetailPage> {
  int _selectedTabIndex = 0;
  final List<String> tabNames = ['개요', '일별시세', '재무', '뉴스/공시'];
  
  final StockDetailRepository _repository = StockDetailRepository();
  StockOverview? _overviewData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOverview();
  }

  Future<void> _fetchOverview() async {
    setState(() => _isLoading = true);
    final data = await _repository.getStockOverview(widget.stockCode);
    if (mounted) {
      setState(() {
        _overviewData = data;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 로딩 중이거나 데이터가 없으면 기본값 또는 로딩 표시
    final stockName = _overviewData?.stockName ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$stockName (${widget.stockCode})',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        titleSpacing: 0,
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : IndexedStack(
              index: _selectedTabIndex,
              children: [
                OverviewTab(overview: _overviewData),
                DailyPriceTab(stockCode: widget.stockCode),
                FinancialsTab(
                  stockName: stockName,
                  stockCode: widget.stockCode,
                ),
                NewsAnnouncementsTab(stockCode: widget.stockCode),
              ],
            ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedTabIndex,
      onTap: (index) {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey[600],
      selectedFontSize: 12,
      unselectedFontSize: 12,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: '개요'),
        BottomNavigationBarItem(icon: Icon(Icons.candlestick_chart), label: '일별시세'),
        BottomNavigationBarItem(icon: Icon(Icons.assessment), label: '재무'),
        BottomNavigationBarItem(icon: Icon(Icons.article), label: '뉴스/공시'),
      ],
    );
  }
}
