import 'package:flutter/material.dart';
import '../models/stock.dart';

class StockRow extends StatelessWidget {

  const StockRow({super.key, required this.stock});
  final Stock stock;

  @override
  Widget build(BuildContext context) {
    final Color priceColor =
        stock.changeAmount > 0
            ? const Color(0xFF1B8A3E)
            : stock.changeAmount < 0
                ? const Color(0xFFD32F2F)
                : Colors.black87;

    final String sign = stock.changeAmount > 0 ? '+' : '';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFEEEEEE), width: 0.8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: symbol + exchange
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stock.symbol,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                stock.exchange,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF9E9E9E),
                ),
              ),
            ],
          ),

          // Right: price + change
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatPrice(stock.currentPrice),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: priceColor,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                '$sign${_formatPrice(stock.changeAmount)} ($sign${stock.changePercent.toStringAsFixed(2)}%)',
                style: TextStyle(
                  fontSize: 11,
                  color: priceColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatPrice(double value) {
    if (value.abs() >= 1000) {
      // Format with commas for Indian numbering
      final parts = value.toStringAsFixed(2).split('.');
      final intPart = parts[0].replaceAll('-', '');
      final isNeg = value < 0;
      final formatted = _addIndianCommas(intPart);
      return '${isNeg ? '-' : ''}$formatted.${parts[1]}';
    }
    return value.toStringAsFixed(2);
  }

  String _addIndianCommas(String s) {
    if (s.length <= 3) return s;
    final last3 = s.substring(s.length - 3);
    final rest = s.substring(0, s.length - 3);
    final buffer = StringBuffer();
    for (int i = 0; i < rest.length; i++) {
      if (i > 0 && (rest.length - i) % 2 == 0) buffer.write(',');
      buffer.write(rest[i]);
    }
    return '${buffer.toString()},$last3';
  }
}
