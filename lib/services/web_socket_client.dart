import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class WebsocketClient {
  IOWebSocketChannel ? channel;

  WebsocketClient() {
    // TODO: create some controllers to receive the data
  }

  void connect(String url, Map<String, String> headers) {
    if (channel != null && channel!.closeCode == null) {
      debugPrint('Already connected!');
      return;
    }

    debugPrint('Connecting to the server...');

    channel = IOWebSocketChannel.connect(url, headers: headers);
    channel!.stream.listen(
      (event) {

      }, 
      onDone: () {
        debugPrint('Connection closed');
      }, 
      onError: (error) {
        debugPrint('Error $error');
      }
    ); 
  }

  void send(String data) {
    if (channel == null || channel!.closeCode != null) {
      debugPrint('Not connected');
      return;
    }
    channel!.sink.add(data);
  }

  // Stream<Map<String, dynamic>> messageUpdates() {
  //   return messageController.stream;
  // }

  void disconnect() {
    if (channel == null || channel!.closeCode != null) {
      debugPrint('Not connected');
      return;
    }
    channel!.sink.close();

    // messageController.close();
    // _initializeControllers();
  }
}