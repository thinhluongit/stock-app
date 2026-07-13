import 'dart:async';

import 'package:stock_app/data/models/models.dart';
import 'package:stock_app/services/socket_service.dart';

class StockService {

  StockService(this.socketService){

      socketService.onPriceUpdate(_onPriceUpdate);

  }

  final SocketService socketService;

  final _controller =
      StreamController<List<StockQuote>>.broadcast();

  Stream<List<StockQuote>>
      get stream=>_controller.stream;

  void _onPriceUpdate(dynamic data){

      final quotes=(data as List)

          .map(
              (e)=>StockQuote.fromJson(e),
          )

          .toList();

      _controller.add(quotes);

  }

  void dispose(){

      _controller.close();

  }

}