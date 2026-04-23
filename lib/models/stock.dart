import 'package:equatable/equatable.dart';

class Stock extends Equatable {
  final String id;
  final String symbol;
  final String exchange; // e.g. "NSE | EQ", "IDX", "NSE | Monthly"
  final double currentPrice;
  final double changeAmount;
  final double changePercent;

  const Stock({
    required this.id,
    required this.symbol,
    required this.exchange,
    required this.currentPrice,
    required this.changeAmount,
    required this.changePercent,
  });

  bool get isPositive => changeAmount >= 0;

  Stock copyWith({
    String? id,
    String? symbol,
    String? exchange,
    double? currentPrice,
    double? changeAmount,
    double? changePercent,
  }) {
    return Stock(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      exchange: exchange ?? this.exchange,
      currentPrice: currentPrice ?? this.currentPrice,
      changeAmount: changeAmount ?? this.changeAmount,
      changePercent: changePercent ?? this.changePercent,
    );
  }

  @override
  List<Object?> get props =>
      [id, symbol, exchange, currentPrice, changeAmount, changePercent];
}
