import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/watchlist_bloc.dart';
import 'data/stock_repository.dart';
import 'screens/watchlist_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const TradeApp());
}

class TradeApp extends StatelessWidget {
  const TradeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '021 Trade',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: RepositoryProvider(
        create: (_) => StockRepository(),
        child: BlocProvider(
          create: (context) => WatchlistBloc(
            repository: context.read<StockRepository>(),
          )..add(const WatchlistStarted()),
          child: const WatchlistScreen(),
        ),
      ),
    );
  }
}
