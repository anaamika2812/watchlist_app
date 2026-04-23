import '../models/stock.dart';
import '../models/watchlist.dart';

class StockRepository {
  List<Watchlist> getWatchLists() {
    return [
      const Watchlist(
        id: 'w1',
        name: 'Watchlist 1',
        stocks: [
          Stock(
            id: '1',
            symbol: 'RELIANCE',
            exchange: 'NSE | EQ',
            currentPrice: 1374.10,
            changeAmount: -4.40,
            changePercent: -0.32,
          ),
          Stock(
            id: '2',
            symbol: 'HDFCBANK',
            exchange: 'NSE | EQ',
            currentPrice: 966.95,
            changeAmount: 0.95,
            changePercent: 0.10,
          ),
          Stock(
            id: '3',
            symbol: 'ASIANPAINT',
            exchange: 'NSE | EQ',
            currentPrice: 2537.40,
            changeAmount: 6.60,
            changePercent: 0.26,
          ),
          Stock(
            id: '4',
            symbol: 'NIFTY IT',
            exchange: 'IDX',
            currentPrice: 35184.30,
            changeAmount: 873.86,
            changePercent: 2.55,
          ),
          Stock(
            id: '5',
            symbol: 'RELIANCE SEP 1880 CE',
            exchange: 'NSE | Monthly',
            currentPrice: 0.00,
            changeAmount: 0.00,
            changePercent: 0.00,
          ),
          Stock(
            id: '6',
            symbol: 'RELIANCE SEP 1370 PE',
            exchange: 'NSE | Monthly',
            currentPrice: 19.20,
            changeAmount: 1.00,
            changePercent: 5.49,
          ),
          Stock(
            id: '7',
            symbol: 'MRF',
            exchange: 'NSE | EQ',
            currentPrice: 147625.00,
            changeAmount: 550.00,
            changePercent: 0.37,
          ),
          Stock(
            id: '8',
            symbol: 'MRF',
            exchange: 'BSE | EQ',
            currentPrice: 147439.45,
            changeAmount: 463.80,
            changePercent: 0.32,
          ),
        ],
      ),
      const Watchlist(
        id: 'w2',
        name: 'Watchlist 5',
        stocks: [
          Stock(
            id: '9',
            symbol: 'TCS',
            exchange: 'NSE | EQ',
            currentPrice: 3921.15,
            changeAmount: -45.80,
            changePercent: -1.15,
          ),
          Stock(
            id: '10',
            symbol: 'INFY',
            exchange: 'NSE | EQ',
            currentPrice: 1482.90,
            changeAmount: -18.35,
            changePercent: -1.22,
          ),
          Stock(
            id: '11',
            symbol: 'WIPRO',
            exchange: 'NSE | EQ',
            currentPrice: 462.30,
            changeAmount: -5.15,
            changePercent: -1.10,
          ),
        ],
      ),
      const Watchlist(
        id: 'w3',
        name: 'Watchlist 6',
        stocks: [
          Stock(
            id: '12',
            symbol: 'AXISBANK',
            exchange: 'NSE | EQ',
            currentPrice: 1098.75,
            changeAmount: 22.40,
            changePercent: 2.08,
          ),
          Stock(
            id: '13',
            symbol: 'SBIN',
            exchange: 'NSE | EQ',
            currentPrice: 812.45,
            changeAmount: 6.30,
            changePercent: 0.78,
          ),
        ],
      ),
    ];
  }
}
