

import 'package:chatapp/services/api_client.dart';
import 'package:models/models.dart';

class MessageRepository {
  final ApiClient apiClient;
  // final WebSocketClient webSocketClient;

  MessageRepository({ required this.apiClient });

  createMessage() {
    throw UnimplementedError();
  }

  Future<List<Message>> fetchMessages(String chatRoomId) async {
    final response = await apiClient.fetchMessages(chatRoomId);
    final messages = response['messages']
      .map<Message>((message) => Message.fromJson(message))
      .toList();

    return messages;
  }
}