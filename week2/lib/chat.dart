import 'package:flutter/material.dart';

class ChatRoom {
  final String name;
  final String lastMessage;

  ChatRoom({
    required this.name,
    required this.lastMessage,
  });
}


class ChatPage extends StatefulWidget {
  final ChatRoom chatRoom;

  const ChatPage({Key? key, required this.chatRoom}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Message> messages = [];

  final messageController = TextEditingController();

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatRoom.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ListTile(
                  title: Text(message.content),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: messageController,
                    decoration: InputDecoration(
                      labelText: '메시지 입력',
                    ),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    final messageContent = messageController.text;
                    if (messageContent.isNotEmpty) {
                      final message = Message(content: messageContent);
                      setState(() {
                        messages.add(message);
                      });
                      messageController.clear();
                    }
                  },
                  child: Text('전송'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Message {
  final String content;

  Message({required this.content});
}
