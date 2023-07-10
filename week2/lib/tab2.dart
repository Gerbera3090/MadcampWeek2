import 'package:flutter/material.dart';
import 'package:week2/chat.dart';

class Tab2Page extends StatefulWidget {
  Tab2Page({Key? key}) : super(key: key);

  @override
  _Tab2PageState createState() => _Tab2PageState();
}

class _Tab2PageState extends State<Tab2Page> {
  List<ChatRoom> chatRooms = [
    ChatRoom(
      name: '채팅방 1',
      lastMessage: '안녕하세요',
    ),
    ChatRoom(
      name: '채팅방 2',
      lastMessage: '오늘 날씨 어때요?',
    ),
    ChatRoom(
      name: '채팅방 3',
      lastMessage: '저녁에 같이 식사할까요?',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: chatRooms.length,
        itemBuilder: (context, index) {
          final chatRoom = chatRooms[index];
          return ListTile(
            title: Text(chatRoom.name),
            subtitle: Text(chatRoom.lastMessage),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(chatRoom: chatRoom),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ChatRoomData {
  final String name;
  final String lastMessage;

  ChatRoomData({
    required this.name,
    required this.lastMessage,
  });
}
