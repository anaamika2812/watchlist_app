import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/watchlist_bloc.dart';
import '../widgets/stock_row.dart';
import 'edit_watchlist_screen.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchlistBloc, WatchlistState>(
      builder: (context, state) {
        if (state is WatchlistLoading || state is WatchlistInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is! WatchlistReady) return const SizedBox.shrink();

        return DefaultTabController(
          length: state.watchlists.length,
          initialIndex: state.activeTabIndex,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                children: [
                  _buildHeader(context, state),
                  _buildSearchBar(),
                  _buildTabBar(context, state),
                  _buildSortRow(),
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  Expanded(
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: state.watchlists.asMap().entries.map((entry) {
                        final wl = entry.value;
                        return GestureDetector(
                          // Long press any item → navigate to edit screen
                          onLongPress: () {},
                          child: ListView.builder(
                            itemCount: wl.stocks.length,
                            itemBuilder: (context, index) {
                              final stock = wl.stocks[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => BlocProvider.value(
                                        value: context.read<WatchlistBloc>(),
                                        child: EditWatchlistScreen(
                                            watchlist: wl),
                                      ),
                                    ),
                                  );
                                },
                                child: StockRow(stock: stock),
                              );
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: _buildBottomNav(),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, WatchlistReady state) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        children: [
          // SENSEX
          Expanded(
            child: _HeaderIndex(
              label: 'SENSEX 18TH SEP 8...',
              exchange: 'BSE',
              price: state.sensexPrice,
              change: state.sensexChange,
              changePercent: state.sensexChangePercent,
            ),
          ),
          Container(width: 1, height: 60, color: const Color(0xFFEEEEEE)),
          // NIFTY BANK
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _HeaderIndex(
                    label: 'NIFTY BANK',
                    exchange: '',
                    price: state.niftyBankPrice,
                    change: state.niftyBankChange,
                    changePercent: state.niftyBankChangePercent,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(Icons.chevron_right,
                      color: Colors.black54, size: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 10, 12, 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Row(
        children: [
          Icon(Icons.search, color: Color(0xFF9E9E9E), size: 20),
          SizedBox(width: 8),
          Text(
            'Search for instruments',
            style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context, WatchlistReady state) {
    return TabBar(
      onTap: (index) =>
          context.read<WatchlistBloc>().add(WatchlistTabChanged(index)),
      isScrollable: true,
      labelColor: Colors.black87,
      unselectedLabelColor: const Color(0xFF9E9E9E),
      labelStyle:
          const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      unselectedLabelStyle:
          const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      indicatorColor: Colors.black87,
      indicatorWeight: 2.5,
      tabs: state.watchlists
          .map((wl) => Tab(text: wl.name))
          .toList(),
    );
  }

  Widget _buildSortRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
      child: Row(
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFDDDDDD)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Row(
              children: [
                Icon(Icons.tune, size: 15, color: Colors.black54),
                SizedBox(width: 5),
                Text('Sort by',
                    style:
                        TextStyle(fontSize: 13, color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.black87,
      unselectedItemColor: const Color(0xFF9E9E9E),
      selectedFontSize: 11,
      unselectedFontSize: 11,
      currentIndex: 0,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border), label: 'Watchlist'),
        BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined), label: 'Orders'),
        BottomNavigationBarItem(
            icon: Icon(Icons.bolt_outlined), label: 'GTT+'),
        BottomNavigationBarItem(
            icon: Icon(Icons.work_outline), label: 'Portfolio'),
        BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'Funds'),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
    );
  }
}

class _HeaderIndex extends StatelessWidget {
  final String label;
  final String exchange;
  final double price;
  final double change;
  final double changePercent;

  const _HeaderIndex({
    required this.label,
    required this.exchange,
    required this.price,
    required this.change,
    required this.changePercent,
  });

  @override
  Widget build(BuildContext context) {
    final bool isUp = change >= 0;
    final Color color =
        isUp ? const Color(0xFF1B8A3E) : const Color(0xFFD32F2F);
    final String sign = isUp ? '+' : '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (exchange.isNotEmpty)
                Text(
                  exchange,
                  style: const TextStyle(
                      fontSize: 10, color: Color(0xFF9E9E9E)),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            price.toStringAsFixed(2),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          Text(
            '$sign${change.toStringAsFixed(2)} ($sign${changePercent.toStringAsFixed(2)}%)',
            style: TextStyle(fontSize: 11, color: color),
          ),
        ],
      ),
    );
  }
}
