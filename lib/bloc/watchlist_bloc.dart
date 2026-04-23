import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/stock_repository.dart';
import '../models/stock.dart';
import '../models/watchlist.dart';

part 'watchlist_event.dart';
part 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  final StockRepository repository;
  Timer? _ticker;
  final Random _random = Random();

  WatchlistBloc({required this.repository}) : super(const WatchlistInitial()) {
    on<WatchlistStarted>(_onStarted);
    on<WatchlistTabChanged>(_onTabChanged);
    on<WatchlistTickerUpdated>(_onTickerUpdated);
    on<WatchlistReordered>(_onReordered);
    on<WatchlistStockDeleted>(_onStockDeleted);
    on<WatchlistSaved>(_onSaved);
  }

  void _onStarted(WatchlistStarted event, Emitter<WatchlistState> emit) {
    emit(const WatchlistLoading());
    final watchlists = repository.getWatchLists();
    emit(WatchlistReady(
      watchlists: watchlists,
      activeTabIndex: 0,
      sensexPrice: 1225.55,
      sensexChange: 144.50,
      sensexChangePercent: 13.37,
      niftyBankPrice: 54172.15,
      niftyBankChange: -14.75,
      niftyBankChangePercent: -0.03,
    ));

    // Start live price simulation ticker
    _ticker = Timer.periodic(const Duration(milliseconds: 1500), (_) {
      add(const WatchlistTickerUpdated());
    });
  }

  void _onTabChanged(WatchlistTabChanged event, Emitter<WatchlistState> emit) {
    final current = state;
    if (current is! WatchlistReady) return;
    emit(current.copyWith(activeTabIndex: event.tabIndex));
  }

  void _onTickerUpdated(
      WatchlistTickerUpdated event, Emitter<WatchlistState> emit) {
    final current = state;
    if (current is! WatchlistReady) return;

    double nudge(double price) {
      final delta = (price * 0.001) * (_random.nextDouble() * 2 - 1);
      return double.parse((price + delta).toStringAsFixed(2));
    }

    final newSensexPrice = nudge(current.sensexPrice);
    final newSensexChange =
        double.parse((newSensexPrice - 1081.05).toStringAsFixed(2));
    final newSensexPct =
        double.parse(((newSensexChange / 1081.05) * 100).toStringAsFixed(2));

    final newNiftyPrice = nudge(current.niftyBankPrice);
    final newNiftyChange =
        double.parse((newNiftyPrice - 54186.90).toStringAsFixed(2));
    final newNiftyPct =
        double.parse(((newNiftyChange / 54186.90) * 100).toStringAsFixed(2));

    final updatedWatchLists = current.watchlists.map((wl) {
      final updatedStocks = wl.stocks.map((stock) {
        if (stock.currentPrice == 0.0) return stock;
        final newPrice = nudge(stock.currentPrice);
        final change = double.parse(
            (newPrice - (stock.currentPrice - stock.changeAmount))
                .toStringAsFixed(2));
        final pct = double.parse(
            ((change / (stock.currentPrice - stock.changeAmount)) * 100)
                .toStringAsFixed(2));
        return stock.copyWith(
          currentPrice: newPrice,
          changeAmount: change,
          changePercent: pct,
        );
      }).toList();
      return wl.copyWith(stocks: updatedStocks);
    }).toList();

    emit(current.copyWith(
      watchlists: updatedWatchLists,
      sensexPrice: newSensexPrice,
      sensexChange: newSensexChange,
      sensexChangePercent: newSensexPct,
      niftyBankPrice: newNiftyPrice,
      niftyBankChange: newNiftyChange,
      niftyBankChangePercent: newNiftyPct,
    ));
  }

  void _onReordered(WatchlistReordered event, Emitter<WatchlistState> emit) {
    final current = state;
    if (current is! WatchlistReady) return;

    final updatedWatchlists = current.watchlists.map((wl) {
      if (wl.id != event.watchlistId) return wl;
      final stocks = List<Stock>.from(wl.stocks);
      final adjusted = event.newIndex > event.oldIndex
          ? event.newIndex - 1
          : event.newIndex;
      final moved = stocks.removeAt(event.oldIndex);
      stocks.insert(adjusted, moved);
      return wl.copyWith(stocks: stocks);
    }).toList();

    emit(current.copyWith(watchlists: updatedWatchlists));
  }

  void _onStockDeleted(
      WatchlistStockDeleted event, Emitter<WatchlistState> emit) {
    final current = state;
    if (current is! WatchlistReady) return;

    final updatedWatchlists = current.watchlists.map((wl) {
      if (wl.id != event.watchlistId) return wl;
      final stocks = wl.stocks.where((s) => s.id != event.stockId).toList();
      return wl.copyWith(stocks: stocks);
    }).toList();

    emit(current.copyWith(watchlists: updatedWatchlists));
  }

  void _onSaved(WatchlistSaved event, Emitter<WatchlistState> emit) {
    final current = state;
    if (current is! WatchlistReady) return;

    final updatedWatchlists = current.watchlists.map((wl) {
      if (wl.id != event.watchlistId) return wl;
      return wl.copyWith(name: event.newName, stocks: event.reorderedStocks);
    }).toList();

    emit(current.copyWith(watchlists: updatedWatchlists));
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    return super.close();
  }
}
