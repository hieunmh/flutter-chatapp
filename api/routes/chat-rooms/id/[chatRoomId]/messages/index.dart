import 'dart:async';
import 'dart:io';

import 'package:api/src/repositories/message_repository.dart';
import 'package:dart_frog/dart_frog.dart';

FutureOr<Response> onRequest(RequestContext context, String chatRoomId) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _get(context, chatRoomId);

    case HttpMethod.post:
    case HttpMethod.put:
    case HttpMethod.delete:
    case HttpMethod.patch:
    case HttpMethod.head:
    case HttpMethod.options:
      return Response(statusCode: HttpStatus.methodNotAllowed);

    // default:
  }
}

FutureOr<Response> _get(RequestContext context, String chatRoomId) async {
  // use message responsitory

  final messageRepository = context.read<MessageRepository>();

  try {
    // create a list of message and return them insid the response
    final messages =  messageRepository.fetchMessages(chatRoomId);
    return Response.json(body: { 'messages': messages });

  } catch (e) {
    return Response.json(
      body: {'error': e.toString()},
      statusCode: HttpStatus.internalServerError,
    );
  }
}
