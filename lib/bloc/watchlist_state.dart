part of 'watchlist_bloc.dart';

abstract class WatchlistState extends Equatable {
  const WatchlistState();

  @override
  List<Object?> get props => [];
}

class WatchlistInitial extends WatchlistState {
  const WatchlistInitial();
}

class WatchlistLoading extends WatchlistState {
  const WatchlistLoading();
}

class WatchlistReady extends WatchlistState {
  final List<Watchlist> watchlists;
  final int activeTabIndex;

  final double sensexPrice;
  final double sensexChange;
  final double sensexChangePercent;
  final double niftyBankPrice;
  final double niftyBankChange;
  final double niftyBankChangePercent;

  const WatchlistReady({
    required this.watchlists,
    required this.activeTabIndex,
    required this.sensexPrice,
    required this.sensexChange,
    required this.sensexChangePercent,
    required this.niftyBankPrice,
    required this.niftyBankChange,
    required this.niftyBankChangePercent,
  });

  Watchlist get activeWatchlist => watchlists[activeTabIndex];

  WatchlistReady copyWith({
    List<Watchlist>? watchlists,
    int? activeTabIndex,
    double? sensexPrice,
    double? sensexChange,
    double? sensexChangePercent,
    double? niftyBankPrice,
    double? niftyBankChange,
    double? niftyBankChangePercent,
  }) {
    return WatchlistReady(
      watchlists: watchlists ?? this.watchlists,
      activeTabIndex: activeTabIndex ?? this.activeTabIndex,
      sensexPrice: sensexPrice ?? this.sensexPrice,
      sensexChange: sensexChange ?? this.sensexChange,
      sensexChangePercent: sensexChangePercent ?? this.sensexChangePercent,
      niftyBankPrice: niftyBankPrice ?? this.niftyBankPrice,
      niftyBankChange: niftyBankChange ?? this.niftyBankChange,
      niftyBankChangePercent:
          niftyBankChangePercent ?? this.niftyBankChangePercent,
    );
  }

  @override
  List<Object?> get props => [
        watchlists,
        activeTabIndex,
        sensexPrice,
        sensexChange,
        sensexChangePercent,
        niftyBankPrice,
        niftyBankChange,
        niftyBankChangePercent,
      ];
}
