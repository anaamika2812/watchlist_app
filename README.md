# 021 Trade – Watchlist Assignment

A Flutter application implementing a reorderable stock watchlist using the BLoC architecture pattern, built as part of the 021 Trade Flutter Developer assignment.

---

## Features

- **Live Ticking Prices**: Header indices (SENSEX, NIFTY BANK) and all stock prices update every 1.5 seconds simulating a real market feed.
- **Multiple Watchlists**: Tab bar with Watchlist 1, Watchlist 5, Watchlist 6 — each holding independent stock lists.
- **Single Tap to Edit**: Tap any stock row on the main screen to navigate to the Edit Watchlist screen.
- **Drag-to-Reorder**: On the Edit screen, grab the `≡` handle and drag to reorder stocks. BLoC state updates on Save.
- **Delete Stock**: Tap the 🗑 icon on the Edit screen to remove a stock from the watchlist.
- **Rename Watchlist**: Tap the ✏️ pencil icon on the Edit screen to rename the watchlist inline.
- **Save / Discard**: Changes on the Edit screen are committed to BLoC only when "Save Watchlist" is tapped.

---

## Project Structure

```
lib/
├── main.dart                         # App entry point; RepositoryProvider + BlocProvider setup
│
├── models/
│   ├── stock.dart                    # Stock data class (Equatable, copyWith)
│   └── watchlist.dart                # Watchlist data class (id, name, List<Stock>)
│
├── data/
│   └── stock_repository.dart         # Static sample data — 3 watchlists, 13 NSE/BSE stocks
│
├── bloc/
│   ├── watchlist_bloc.dart           # Business logic; Timer-based ticker, reorder, delete, save
│   ├── watchlist_event.dart          # 6 events: Started, TabChanged, TickerUpdated, Reordered, StockDeleted, Saved
│   └── watchlist_state.dart          # 3 states: Initial, Loading, Ready (carries all watchlists + header values)
│
├── screens/
│   ├── watchlist_screen.dart         # Screen 1: live list, tab bar, bottom nav
│   └── edit_watchlist_screen.dart    # Screen 2: reorder, delete, rename, save
│
└── widgets/
    └── stock_row.dart                # Single stock row with Indian number formatting
```

---

## Screen Flow

```
WatchlistScreen  ──(tap any stock)──▶  EditWatchlistScreen
     │                                        │
     │  BlocBuilder rebuilds on               │  Local setState for drag/delete
     │  every TickerUpdated state             │  BLoC updated only on Save
     │                                        │
     └──────────────(Navigator.pop)───────────┘
```

---

## BLoC Architecture

### Events

| Event | Trigger | Payload |
|---|---|---|
| `WatchlistStarted` | App startup | — |
| `WatchlistTabChanged` | Tab bar tap | `tabIndex` |
| `WatchlistTickerUpdated` | Timer every 1.5s | — |
| `WatchlistReordered` | Drag completed (Edit screen) | `watchlistId`, `oldIndex`, `newIndex` |
| `WatchlistStockDeleted` | Delete icon tapped | `watchlistId`, `stockId` |
| `WatchlistSaved` | Save Watchlist tapped | `watchlistId`, `newName`, `reorderedStocks` |

### States

| State | Meaning |
|---|---|
| `WatchlistInitial` | Before data is loaded |
| `WatchlistLoading` | Data fetch in progress |
| `WatchlistReady` | Carries all watchlists, active tab index, and live header values |

### Reorder Index Correction

Flutter's `ReorderableListView` reports `newIndex` *after* removing the item from its original position. Moving an item downward makes `newIndex` one higher than expected. The correction:

```dart
final int adjusted = newIndex > oldIndex ? newIndex - 1 : newIndex;
```

### Drag Handle — Gesture Conflict Fix

Setting `buildDefaultDragHandles: false` and wrapping only the `≡` icon with `ReorderableDragStartListener` ensures dragging is triggered exclusively from the handle — preventing conflicts with the delete button tap:

```dart
ReorderableDragStartListener(
  index: index,
  child: const Icon(Icons.drag_handle_rounded),
)
```

---

## Data Models

```dart
class Stock extends Equatable {
  final String id;
  final String symbol;       // e.g. "RELIANCE"
  final String exchange;     // e.g. "NSE | EQ", "IDX", "NSE | Monthly"
  final double currentPrice;
  final double changeAmount;
  final double changePercent;
}

class Watchlist extends Equatable {
  final String id;
  final String name;         // e.g. "Watchlist 1"
  final List<Stock> stocks;
}
```

Both extend `Equatable` so `BlocBuilder` skips rebuilds when state is unchanged.

---

## Live Price Simulation

A `Timer.periodic` inside the BLoC fires every 1.5 seconds:

```dart
_ticker = Timer.periodic(const Duration(milliseconds: 1500), (_) {
  add(const WatchlistTickerUpdated());
});
```

Each tick applies a small random nudge (±0.1%) to every stock price and both header indices, then emits a new `WatchlistReady` state. The timer is cancelled in `close()` to prevent memory leaks:

```dart
@override
Future<void> close() {
  _ticker?.cancel();
  return super.close();
}
```

---

## Dependency Injection

`RepositoryProvider` provides `StockRepository` above `BlocProvider`, so the BLoC reads it from context rather than constructing it directly:

```dart
RepositoryProvider(
  create: (_) => StockRepository(),
  child: BlocProvider(
    create: (context) => WatchlistBloc(
      repository: context.read<StockRepository>(),
    )..add(const WatchlistStarted()),
    child: const WatchlistScreen(),
  ),
),
```

This means swapping static data for a live WebSocket repository requires no changes to the BLoC or UI.

---

## Getting Started

### Prerequisites
- Flutter SDK ≥ 3.0.0
- Dart SDK ≥ 3.0.0

### Run
```bash
git clone <repo-url>
cd watchlist_app
flutter pub get
flutter run
```

### Dependencies

| Package | Version | Purpose |
|---|---|---|
| `flutter_bloc` | ^8.1.4 | BLoC state management |
| `equatable` | ^2.0.5 | Value equality for states/models |

---

## Design Decisions

1. **`ReorderableListView.builder`** over basic `ReorderableListView` — supports lazy rendering for large lists.
2. **`buildDefaultDragHandles: false`** with `ReorderableDragStartListener` on the handle icon — eliminates gesture conflicts with other interactive widgets on the row.
3. **Local `setState` on Edit screen** for intermediate drag/delete operations — BLoC is updated only on explicit Save, keeping undo/discard straightforward.
4. **`part` / `part of` directives** keep events and states in separate files while sharing the same library scope as the bloc — idiomatic for `flutter_bloc` projects.
5. **`Timer` inside BLoC** for price simulation — keeps ticker lifecycle tied to BLoC lifecycle, automatically cleaned up on `close()`.
6. **Indian number formatting** in `stock_row.dart` done without any external package using a simple recursive comma-insertion algorithm.

---

## Potential Extensions

- Live WebSocket feed replacing the Timer-based simulation
- Search / filter bar for instruments
- Persistent watchlist ordering via `SharedPreferences` or Hive
- Buy / Sell action sheet on stock tap
- Portfolio and Orders screens wired to separate BLoCs
