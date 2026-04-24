part of 'watchlist_bloc.dart';

abstract class WatchlistEvent extends Equatable {
  const WatchlistEvent();

  @override
  List<Object?> get props => [];
}

class WatchlistStarted extends WatchlistEvent {
  const WatchlistStarted();
}

class WatchlistTabChanged extends WatchlistEvent {
  final int tabIndex;
  const WatchlistTabChanged(this.tabIndex);

  @override
  List<Object?> get props => [tabIndex];
}

class WatchlistTickerUpdated extends WatchlistEvent {
  const WatchlistTickerUpdated();
}

class WatchlistReordered extends WatchlistEvent {
  final String watchlistId;
  final int oldIndex;
  final int newIndex;

  const WatchlistReordered({
    required this.watchlistId,
    required this.oldIndex,
    required this.newIndex,
  });

  @override
  List<Object?> get props => [watchlistId, oldIndex, newIndex];
}

class WatchlistStockDeleted extends WatchlistEvent {
  final String watchlistId;
  final String stockId;

  const WatchlistStockDeleted({
    required this.watchlistId,
    required this.stockId,
  });

  @override
  List<Object?> get props => [watchlistId, stockId];
}

/// Rename a watchlist (from Edit screen).
class WatchlistRenamed extends WatchlistEvent {
  final String watchlistId;
  final String newName;

  const WatchlistRenamed({required this.watchlistId, required this.newName});

  @override
  List<Object?> get props => [watchlistId, newName];
}

class WatchlistSaved extends WatchlistEvent {
  final String watchlistId;
  final String newName;
  final List<Stock> reorderedStocks;

  const WatchlistSaved({
    required this.watchlistId,
    required this.newName,
    required this.reorderedStocks,
  });

  @override
  List<Object?> get props => [watchlistId, newName, reorderedStocks];
}
