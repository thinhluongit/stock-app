// import 'package:flutter/material.dart';
// import 'package:stock_app/data/models/models.dart';
// import 'package:stock_app/data/models/order.dart';
// import 'package:stock_app/data/models/trading_info.dart';
// import 'package:stock_app/providers/user_provider.dart';
// import 'package:stock_app/services/stock_service.dart';
// import 'package:uuid/uuid.dart';

// class TradingProvider extends ChangeNotifier {
  
//   bool _isLoading = false;

//   StockQuote? _selectedQuote;
//   TradingInfo? _tradingInfo;
//   final StockService _stockService = StockService();
//  final UserProvider userProvider;
 
//   bool get isLoading => _isLoading;
//   StockQuote? get selectedQuote => _selectedQuote;
//   TradingInfo? get tradingInfo => _tradingInfo;

//   Order? _order;

//   Order? get order => _order;

//   Future<void> updateSelectedSymbol(String symbol) async {
//     _isLoading = true;
//     notifyListeners();

//     _selectedQuote = await _stockService.getQuote(symbol);

//     _order = Order(
//       id: const Uuid().v4(),
//       accountNo: currentAccount,
//       symbol: symbol,
//       side: OrderSide.buy,
//       orderType: OrderType.limit,
//       price: _selectedQuote!.price,
//       volume: 100,
//       orderTime: DateTime.now(),
//     );

//     _isLoading = false;
//     notifyListeners();
//   }
// }
