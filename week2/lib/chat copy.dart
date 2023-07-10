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
  bool sendingMessage = false; // 통신 중 여부를 나타내는 변수

  final messageController = TextEditingController();

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  Future<void> sendMessage() async {
    final messageContent = messageController.text;
    if (messageContent.isNotEmpty) {
      setState(() {
        sendingMessage = true; // 메시지를 보내는 중임을 표시
      });

      // 여기서 서버와의 통신을 시뮬레이션합니다.
      await Future.delayed(Duration(seconds: 2));

      final message = Message(content: messageContent, isMe: true);
      setState(() {
        messages.add(message);
        sendingMessage = false; // 통신 완료 후 표시 제거
      });
      messageController.clear();
    }
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
              itemCount: messages.length + 1, // "보내는 중..." 메시지를 위한 추가 아이템
              itemBuilder: (context, index) {
                if (index < messages.length) {
                  final message = messages[index];
                  return MessageBubble(
                    content: message.content,
                    isMe: message.isMe,
                  );
                } else {
                  // "보내는 중..." 메시지를 표시
                  return ListTile(
                    title: Text(
                      "보내는 중...",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    trailing: CircularProgressIndicator(),
                  );
                }
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
                  onPressed: sendingMessage ? null : sendMessage, // 통신 중일 때 버튼 비활성화
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
  final bool isMe;

  Message({required this.content, this.isMe = false});
}

class MessageBubble extends StatelessWidget {
  final String content;
  final bool isMe;

  const MessageBubble({Key? key, required this.content, required this.isMe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bubbleWidth = MediaQuery.of(context).size.width * 0.7; // 말풍선의 최대 너비

    return Container(
      margin: EdgeInsets.only(
        top: 8,
        bottom: 8,
        left: isMe ? 64 : 8, // 오른쪽으로 정렬된 말풍선
        right: isMe ? 8 : 64,
      ),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isMe ? Colors.blue[200] : Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      constraints: BoxConstraints(
        maxWidth: bubbleWidth,
      ),
      child: Text(
        content,
        style: TextStyle(color: isMe ? Colors.white : Colors.black),
      ),
    );
  }
}
