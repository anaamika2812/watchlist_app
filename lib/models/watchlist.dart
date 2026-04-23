import 'package:equatable/equatable.dart';
import 'stock.dart';

class Watchlist extends Equatable {
  final String id;
  final String name;
  final List<Stock> stocks;

  const Watchlist({
    required this.id,
    required this.name,
    required this.stocks,
  });

  Watchlist copyWith({
    String? id,
    String? name,
    List<Stock>? stocks,
  }) {
    return Watchlist(
      id: id ?? this.id,
      name: name ?? this.name,
      stocks: stocks ?? this.stocks,
    );
  }

  @override
  List<Object?> get props => [id, name, stocks];
}
