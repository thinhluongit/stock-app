import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  IO.Socket? _socket;

  bool get isConnected => _socket?.connected ?? false;

  void connect() {
    if (isConnected) return;

    debugPrint("===== SocketService.connect() =====");

    _socket = IO.io(
        "http://192.168.15.96:3000",
        IO.OptionBuilder()
            .enableForceNew()
            .enableReconnection()
            .setTimeout(10000)
            .setTransports(['websocket']).build());

    _socket!.onConnect((_) {
      debugPrint("✅ Connected");
    });

    _socket!.onConnectError((e) {
      debugPrint("❌ Connect Error: $e");
    });

    _socket!.onError((e) {
      debugPrint("❌ Socket Error: $e");
    });

    _socket!.onDisconnect((_) {
      debugPrint("⚠️ Disconnected");
    });

    _socket!.connect();
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }

  void onPriceUpdate(Function(dynamic data) callback) {
    _socket?.on(
      "price_update",
      callback,
    );
  }

  IO.Socket? get socket => _socket;
}
