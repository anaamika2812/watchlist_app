# 021 Trade – Watchlist Assignment

A Flutter application implementing a reorderable stock watchlist using the BLoC architecture pattern, built as part of the 021 Trade Flutter Developer assignment.

---

## Features

- **Drag-to-Reorder**: Long-press any stock tile and drag it to a new position. The BLoC state updates immediately and the list re-renders.
- **Swipe-to-Remove**: Swipe a tile left to trigger a removal confirmation dialog. A snackbar confirms the action.
- **Sparkline Mini-Charts**: Each stock tile displays a custom-painted 8-point sparkline showing recent price movement.
- **Market Summary Bar**: Displays NIFTY 50, SENSEX, and BANK NIFTY index chips at the top.
- **Drag Proxy Animation**: While dragging, the lifted tile scales up slightly and becomes semi-transparent for clear visual feedback.

---

## Project Structure

```
lib/
├── main.dart                   # App entry point; MaterialApp + BlocProvider setup
├── models/
│   └── stock.dart              # Stock data class (Equatable, StockTrend enum)
├── data/
│   └── stock_repository.dart   # Static sample data source (10 NSE stocks)
├── bloc/
│   ├── watchlist_bloc.dart     # Business logic; handles events, emits states
│   ├── watchlist_event.dart    # WatchlistLoaded, WatchlistReordered, WatchlistStockRemoved
│   └── watchlist_state.dart    # WatchlistInitial, WatchlistLoading, WatchlistReady, WatchlistError
├── screens/
│   └── watchlist_screen.dart   # Main screen; BlocBuilder-driven UI
└── widgets/
    ├── stock_tile.dart         # Individual reorderable list item
    └── sparkline_chart.dart    # CustomPainter-based sparkline chart
```

---

## BLoC Architecture

### Events
| Event | Trigger | Payload |
|---|---|---|
| `WatchlistLoaded` | App startup | — |
| `WatchlistReordered` | Drag-drop completed | `oldIndex`, `newIndex` |
| `WatchlistStockRemoved` | Swipe-to-delete confirmed | `stockId` |

### States
| State | Meaning |
|---|---|
| `WatchlistInitial` | Before any data is loaded |
| `WatchlistLoading` | Data fetch in progress |
| `WatchlistReady` | Carries the current `List<Stock>` |
| `WatchlistError` | Holds an error message string |

### Reorder Index Correction
Flutter's `ReorderableListView` reports `newIndex` *after* the item has been removed from its original position. When moving an item *downward* in the list, `newIndex` is therefore one higher than expected. The bloc corrects for this:

```dart
final int adjustedNewIndex =
    event.newIndex > event.oldIndex ? event.newIndex - 1 : event.newIndex;
```

---

## Data Model

```dart
class Stock extends Equatable {
  final String id;
  final String symbol;          // e.g. "RELIANCE"
  final String companyName;     // e.g. "Reliance Industries"
  final double currentPrice;
  final double changeAmount;
  final double changePercent;
  final StockTrend trend;       // up | down | neutral
  final List<double> sparklineData; // 8 data points for the mini-chart
}
```

`Equatable` ensures that `BlocBuilder` only rebuilds when the list actually changes, avoiding unnecessary renders.

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

1. **`ReorderableListView.builder`** was chosen over the basic `ReorderableListView` to support lazy rendering for large lists.
2. **`Dismissible`** wraps each tile to provide swipe-to-remove with a confirmation dialog, preventing accidental deletions.
3. **`CustomPainter` for sparklines** avoids any charting library dependency, keeping the package footprint minimal.
4. **`proxyDecorator`** on `ReorderableListView` provides subtle scale + opacity feedback during drag without any animation library.
5. **`part` / `part of` directives** keep events and states in separate files while sharing the same library scope as the bloc, which is idiomatic for `flutter_bloc` projects.
6. The `StockRepository` is injected into `WatchlistBloc` via its constructor, making it straightforward to swap the static data source for a live API later.

---

## Potential Extensions
- Live WebSocket price feed replacing static data
- Search / filter bar
- Multiple named watchlists with tab navigation
- Persistent ordering via `SharedPreferences` or a local database
