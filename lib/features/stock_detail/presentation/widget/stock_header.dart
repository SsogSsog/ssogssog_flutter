import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  // [핵심 추가] 거래량을 M(백만) 단위로 포맷하는 함수
  String _formatVolume(int volume) {
    if (volume < 1000000) {
      return NumberFormat('#,###').format(volume);
    }
    double newVolume = volume / 1000000.0;
    return '${newVolume.toStringAsFixed(1)}M';
  }

  String _formatPrice(int price) {
    return NumberFormat('#,###').format(price);
  }

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
          // 1. 종목명, 종목코드 + 찜하기 버튼
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(data.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Text(data.code, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                ],
              ),
              IconButton(
                tooltip: '찜하기', // Tooltip 추가
                onPressed: () {
                  // TODO: 찜하기 기능 구현
                },
                icon: const Icon(Icons.favorite_border_rounded, size: 28, color: Colors.grey),
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48), // 최소 탭 영역 보장
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 2. 현재가, KOSDAQ 배지
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(_formatPrice(data.currentPrice), style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
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
          // 3. 등락률
          Row(
            children: [
              Icon(rateIcon, color: rateColor, size: 24),
              Text(_formatPrice(data.change), style: TextStyle(color: rateColor, fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(width: 4),
              Text('(${data.changeRate.toStringAsFixed(2)}%)', style: TextStyle(color: rateColor, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 8),
          // [핵심 수정] 4. 전일가와 거래량을 한 줄에 표시
          Row(
            children: [
              Text('전일 ${_formatPrice(data.prevClose)}', style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w600)),
              const Text('  ·  ', style: TextStyle(color: Colors.grey, fontSize: 12)),
              Text('거래량 ${_formatVolume(data.volume)}', style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          )
        ],
      ),
    );
  }
}
