import 'package:flutter/material.dart';
import 'package:week2/chatroom.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'dart:convert';

class Tab2Page extends StatefulWidget {
  Tab2Page({Key? key}) : super(key: key);

  @override
  _Tab2PageState createState() => _Tab2PageState();
}

class _Tab2PageState extends State<Tab2Page> {
  List<String> nickNameList = [];
  List<String> lastChatList = [];
  List<String> tidList = [];
  List<int> num_unreadList = [];
  List<String> photo_imgList = [];

  @override
  void initState() {
    super.initState();

    print("새로고침!!!!!");

    // 서버에서 질문을 받아오는 비동기 함수를 호출하고 받아온 질문을 questionList에 추가합니다.
    fetchChats().then((chats) {
      final List<String> nickNameListQ =
          chats.map((chatrooms) => chatrooms['nickName'] as String).toList();
      final List<String> lastChatListQ =
          chats.map((chatrooms) => chatrooms['lastChat'] as String).toList();
      final List<String> tidListQ =
          chats.map((chatrooms) => chatrooms['tid'] as String).toList();
      final List<int> num_unreadListQ =
          chats.map((chatrooms) => chatrooms['num_unread'] as int).toList();
      final List<String> photo_imgListQ =
          chats.map((chatrooms) => chatrooms['profile_img'] as String).toList();
      setState(() {
        nickNameList.clear();
        lastChatList.clear();
        tidList.clear();
        num_unreadList.clear();
        photo_imgList.clear();
        nickNameList.addAll(nickNameListQ);
        lastChatList.addAll(lastChatListQ);
        tidList.addAll(tidListQ);
        num_unreadList.addAll(num_unreadListQ);
        photo_imgList.addAll(photo_imgListQ);
      });
    });
  }

Future<List<Map<String, dynamic>>> fetchChats() async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  final url = Uri.parse('$addressUrl/get_chatRooms/');

  final response = await http.post(
    url,
    body: jsonEncode(<String, String>{
      'uid': userProvider.uid,
    }),
  );

  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    final List<dynamic>? chatroomsData = responseData['data']['chatRoomList'];

    if (chatroomsData != null && chatroomsData is List<dynamic>) {
      final List<Map<String, dynamic>> chatrooms = chatroomsData.map((data) {
        return {
          'nickName': data['nickName'] as String? ?? '',
          'lastChat': data['lastChat'] as String? ?? '',
          'tid': data['tid'] as String? ?? '',
          'num_unread': data['num_unread'] as int? ?? '',
          'profile_img': data['profile_img'] as String? ?? '',
          // 'num_replies': data['num_replies'] as int,
        };
      }).toList();

      return chatrooms;
    }
  }

  // 예외를 발생시키지 않고 빈 리스트를 반환합니다.
  return [];
}  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: ListView.builder(
        itemCount: nickNameList.length,
        itemBuilder: (context, index) {
          final nickName = nickNameList[index];
          final lastChat = lastChatList[index];
          final num_unread = num_unreadList[index];
          final tid = tidList[index];
          
          return GestureDetector(
            //누르면 ChatRoomPage로 넘어감
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatRoomPage(
                    tid: tid,
                    nickName: nickName,
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nickName,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Text(
                          lastChat,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Text(
                          num_unread.toString(),
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        reverse: true,
      ),
    );
  }
}