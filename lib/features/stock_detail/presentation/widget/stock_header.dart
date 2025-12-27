import 'package:flutter/material.dart';

// 위젯에 전달될 데이터 모델
class StockHeaderData {
  final String name;
  final String code;
  final int currentPrice;
  final int change;
  final double changeRate;
  final int volume;
  final int prevClose;
  final String market;

  const StockHeaderData({
    required this.name,
    required this.code,
    required this.currentPrice,
    required this.change,
    required this.changeRate,
    required this.volume,
    required this.prevClose,
    required this.market,
  });
}

/// 종목 상세 - 개요 탭의 헤더 위젯
class StockHeader extends StatelessWidget {
  final StockHeaderData data;

  const StockHeader({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final isUp = data.changeRate >= 0;
    final rateColor = isUp ? Colors.red : Colors.blue;
    final rateIcon = isUp ? Icons.arrow_drop_up : Icons.arrow_drop_down;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 종목명, 종목코드
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(data.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Text(data.code, style: const TextStyle(fontSize: 16, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 12),
          // 2. 현재가, 등락 정보
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${data.currentPrice}', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
              // KOSDAQ/KOSPI 정보
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(data.market, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              )
            ],
          ),
          const SizedBox(height: 8),
          // 3. 등락률, 전일가, 거래량
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(rateIcon, color: rateColor, size: 24),
                  Text('${data.change}', style: TextStyle(color: rateColor, fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(width: 4),
                  Text('(${data.changeRate.toStringAsFixed(2)}%)', style: TextStyle(color: rateColor, fontSize: 16)),
                ],
              ),
              Text('거래량 ${data.volume}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 4),
          Text('전일가 ${data.prevClose}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}
