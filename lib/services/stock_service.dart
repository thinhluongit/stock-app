import 'dart:async';
import 'dart:math';

import 'package:stock_app/data/mock/mock_data.dart';
import 'package:stock_app/data/models/models.dart';

class StockService {
  final Random random = Random();

  final _controller = StreamController<List<StockQuote>>.broadcast();

  Stream<List<StockQuote>> get stream => _controller.stream;

  final List<StockQuote> _stocks = List.of(MockData.quotes);

  Stream<List<StockQuote>> getRealtimeStocks() async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 1));

      for (int i = 0; i < _stocks.length; i++) {
        final change = random.nextDouble() * 2 - 1;

        final newPrice = _stocks[i].price + change;
        final newVolume = random.nextDouble() * 10000 + _stocks[i].volume;

        _stocks[i] = _stocks[i].copyWith(
            price: newPrice,
            change: newPrice - _stocks[i].reference,
            percent:
                ((newPrice - _stocks[i].reference) / _stocks[i].reference) *
                    100,
            volume: newVolume);
      }

      yield List.from(_stocks);
    }
  }

  Future<StockQuote> getQuote(String symbol) {
    return Future.value(
      MockData.quotes.firstWhere((q) => q.symbol == symbol),
    );
  }
}
