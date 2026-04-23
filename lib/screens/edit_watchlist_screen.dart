import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/watchlist_bloc.dart';
import '../models/stock.dart';
import '../models/watchlist.dart';

class EditWatchlistScreen extends StatefulWidget {
  final Watchlist watchlist;

  const EditWatchlistScreen({super.key, required this.watchlist});

  @override
  State<EditWatchlistScreen> createState() => _EditWatchlistScreenState();
}

class _EditWatchlistScreenState extends State<EditWatchlistScreen> {
  late List<Stock> _stocks;
  late TextEditingController _nameController;
  bool _isEditingName = false;

  @override
  void initState() {
    super.initState();
    _stocks = List<Stock>.from(widget.watchlist.stocks);
    _nameController = TextEditingController(text: widget.watchlist.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      final adjusted = newIndex > oldIndex ? newIndex - 1 : newIndex;
      final moved = _stocks.removeAt(oldIndex);
      _stocks.insert(adjusted, moved);
    });
  }

  void _deleteStock(String stockId) {
    setState(() {
      _stocks.removeWhere((s) => s.id == stockId);
    });
  }

  void _save() {
    context.read<WatchlistBloc>().add(
          WatchlistSaved(
            watchlistId: widget.watchlist.id,
            newName: _nameController.text.trim(),
            reorderedStocks: _stocks,
          ),
        );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Edit ${widget.watchlist.name}',
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          const Divider(height: 1, color: Color(0xFFEEEEEE)),

          // Watchlist name field
          Container(
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    enabled: _isEditingName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                    onSubmitted: (_) =>
                        setState(() => _isEditingName = false),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() => _isEditingName = true);
                    Future.delayed(const Duration(milliseconds: 50), () {
                      _nameController.selection = TextSelection.fromPosition(
                        TextPosition(offset: _nameController.text.length),
                      );
                    });
                  },
                  child: const Icon(Icons.edit,
                      size: 18, color: Color(0xFF9E9E9E)),
                ),
              ],
            ),
          ),

          // Reorderable stock list
          Expanded(
            child: ReorderableListView.builder(
              itemCount: _stocks.length,
              onReorder: _onReorder,
              buildDefaultDragHandles: false, // we supply our own handle
              proxyDecorator: (child, index, animation) {
                return Material(
                  elevation: 4,
                  shadowColor: Colors.black26,
                  borderRadius: BorderRadius.circular(4),
                  child: child,
                );
              },
              itemBuilder: (context, index) {
                final stock = _stocks[index];
                return _EditStockRow(
                  key: ValueKey(stock.id),
                  index: index,
                  stock: stock,
                  onDelete: () => _deleteStock(stock.id),
                );
              },
            ),
          ),

          // Bottom buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              children: [
                // Edit other watchlists
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.black87, width: 1.2),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                    ),
                    child: const Text(
                      'Edit other watchlists',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Save Watchlist
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Save Watchlist',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EditStockRow extends StatelessWidget {
  final int index;
  final Stock stock;
  final VoidCallback onDelete;

  const _EditStockRow({
    super.key,
    required this.index,
    required this.stock,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Drag handle — only this triggers reorder drag
                ReorderableDragStartListener(
                  index: index,
                  child: const Icon(Icons.drag_handle_rounded,
                      color: Color(0xFF9E9E9E), size: 22),
                ),
                const SizedBox(width: 16),

                // Stock name
                Expanded(
                  child: Text(
                    stock.symbol,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),

                // Delete icon
                GestureDetector(
                  onTap: onDelete,
                  child: const Icon(Icons.delete,
                      color: Colors.black87, size: 20),
                ),
              ],
            ),
          ),
          const Divider(
              height: 1,
              indent: 16,
              endIndent: 16,
              color: Color(0xFFEEEEEE)),
        ],
      ),
    );
  }
}
