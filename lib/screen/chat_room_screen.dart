import 'package:chatapp/widget/avatar.dart';
import 'package:chatapp/widget/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

import '../main.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key, required this.chatRoom});

  final ChatRoom chatRoom;

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final messageController = TextEditingController();
  final List<Message> messages = [];

  @override
  void initState() {
    _loadMessages();
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  _loadMessages() async {
    final _messages = await messageRepository.fetchMessages(widget.chatRoom.id);

    _messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    setState(() {
      messages.addAll(_messages);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.viewInsetsOf(context);

    final currentParticipant = widget.chatRoom.participants.firstWhere(
      (user) => user.id == userId1,
    );

    final otherParticipant = widget.chatRoom.participants.firstWhere(
      (user) => user.id != currentParticipant.id,
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Avatar(imageUrl: otherParticipant.avatarUrl, radius: 18),
            // const SizedBox(height: 2.0),
            Text(
              otherParticipant.username, 
              style: Theme.of(context).textTheme.bodySmall,
            )
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
          const SizedBox(width: 8.0,)
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 8.0,
            bottom: (viewInsets.bottom > 0) ? 8.0 : 0.0,
          ),
          child:
            Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final showImage = index + 1 == messages.length
                    || messages[index + 1].senderUserId != message.senderUserId;


                    return Row(
                      mainAxisAlignment: (message.senderUserId != userId1) ?
                      MainAxisAlignment.end : MainAxisAlignment.start,
                      children: [
                        if (showImage && message.senderUserId == userId1) 
                          Avatar(
                            imageUrl: otherParticipant.avatarUrl, 
                            radius: 12
                          ),
                        MessageBubble(message: message),
                        if (showImage && message.senderUserId != userId1) 
                          Avatar(
                            imageUrl: otherParticipant.avatarUrl, 
                            radius: 12
                          ),
                      ],
                    );
                  },
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // send an image
                    }, 
                    icon: const Icon(Icons.attach_file),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: messageController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).colorScheme
                          .primary.withAlpha(100),
                        hintText: 'Aa',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          borderSide: BorderSide.none
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            // send a message and clear the controller
                          },
                          icon: const Icon(Icons.send)
                        )
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        )
      )
    );
  }
}

