

import 'package:chatapp/services/api_client.dart';
import 'package:chatapp/services/web_socket_client.dart';
import 'package:models/models.dart';

class MessageRepository {
  final ApiClient apiClient;
  final WebsocketClient webSocketClient;

  MessageRepository({ required this.apiClient, required this.webSocketClient });

   Future<void> createMessage(Message message) async {
    final payload = "{'message.create': ${message.toJson() }";
    webSocketClient.send(payload);
  }

  Future<List<Message>> fetchMessages(String chatRoomId) async {
    final response = await apiClient.fetchMessages(chatRoomId);
    final messages = response['messages']
      .map<Message>((message) => Message.fromJson(message))
      .toList();

    return messages;
  }
}