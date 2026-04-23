part of 'watchlist_bloc.dart';

abstract class WatchlistEvent extends Equatable {
  const WatchlistEvent();

  @override
  List<Object?> get props => [];
}

/// Load all watchlists on startup.
class WatchlistStarted extends WatchlistEvent {
  const WatchlistStarted();
}

/// Switch the active watchlist tab.
class WatchlistTabChanged extends WatchlistEvent {
  final int tabIndex;
  const WatchlistTabChanged(this.tabIndex);

  @override
  List<Object?> get props => [tabIndex];
}

/// Tick: update live prices for header indices + active watchlist stocks.
class WatchlistTickerUpdated extends WatchlistEvent {
  const WatchlistTickerUpdated();
}

/// Reorder stocks inside a watchlist (from Edit screen).
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

/// Delete a stock from a watchlist (from Edit screen).
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

/// Save edits from the Edit screen back to the main state.
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
