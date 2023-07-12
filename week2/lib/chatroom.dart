import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:week2/main.dart';
import 'dart:convert';
import 'package:week2/profile.dart';
import 'user_provider.dart';
import 'package:provider/provider.dart';

class Chat {
  String uid;
  String tid;
  String chatRoomId;
  String cText;
  String chatId;
  String time;
  bool like;

  Chat({
    required this.uid,
    this.tid = '',
    this.chatRoomId = '',
    this.cText = '',
    this.chatId = '',
    this.time = '',
    this.like = false,
  });
}

class ChatRoomPage extends StatefulWidget {
  final String tid;
  final String nickName;

  const ChatRoomPage({
    Key? key,
    required this.tid,
    required this.nickName,
  }) : super(key: key);

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  List<Chat> chats = [];
  final commentController = TextEditingController();
  final editController = TextEditingController();
  bool hasCommented = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchComments(widget.tid); // 서버에서 채팅 목록 가져오는 함수 호출
    });
  }

  @override
  void dispose() {
    commentController.dispose();
    editController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('# ${widget.nickName}'), // 지금 대화하는 상대 닉네임
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                final bool isEditable =
                    chat.tid == userProvider.uid; // 사용자의 댓글인지 확인
                return ListTile(
                  // leading: CircleAvatar(
                  //     backgroundImage: MemoryImage(userProvider.photo!)                       // 프로필 사진, 근데 나중에 생각하기
                  //         as ImageProvider<Object>?),
                  title
                  // : chat.isEditing
                  //     ? TextFormField(
                      //         initialValue: chat.rText,
                      //         onFieldSubmitted: (value) {
                      //           //  addComment(index);
                      //           setState(() {
                      //             chat.isEditing = false;
                      //           });
                      //         },
                      //       )
                      : Column(
                    crossAxisAlignment: !isEditable
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: !isEditable
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          if (isEditable) SizedBox(width: 10),
                          Text(
                            '${chat.time}',
                            style: TextStyle(
                              fontSize: 10,
                              color: const Color.fromARGB(255, 109, 109, 109),
                            ),
                          ),
                          if (isEditable) SizedBox(width: 10),
                          if (isEditable)
                            Text(
                              widget.nickName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(chat.cText),
                    ],
                  ),
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
                    controller: commentController,
                    decoration: InputDecoration(
                      labelText: '메시지 보내기',
                    ),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    final commentContent = commentController.text;
                    if (commentContent.isNotEmpty) {
                      addComment(
                          commentContent, widget.tid); // 댓글 추가 함수 호출
                      commentController.clear();
                    }
                  },
                  child: Icon(Icons.check),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Future<void> likeComment(int index) async {
  //   // 채팅에 공감하기
  //   final userProvider = Provider.of<UserProvider>(context, listen: false);

  //   final url = Uri.parse('$addressUrl/like_reply/');

  //   final response = await http.post(
  //     url,
  //     body: jsonEncode(<String, dynamic>{
  //       'uid': userProvider.uid,
  //       'tid': widget.tid,
  //     }),
  //   );

  //   if (response.statusCode == 200) {
  //     print(response.statusCode);

  //     final responseData = jsonDecode(response.body);
  //     final updatedNumLikes = responseData['num_likes'] as int;
  //     // final liked = responseData['liked'] as bool;

  //     setState(() {
  //       Chat[index].num_likes = updatedNumLikes;
  //       Chat[index].liked = !Chat[index].liked;
  //     });
  //   } else {
  //     print(response.statusCode);
  //     throw Exception('Failed to like comment');
  //   }
  // }

  Future<void> fetchComments(String tid) async {
    // 채팅 받아오기

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final url = Uri.parse('$addressUrl/get_chats/');

    final response = await http.post(
      url,
      body: jsonEncode(<String, dynamic>{
        'tid': tid,
        'uid': userProvider.uid,
      }),
    );

    if (response.statusCode == 200) {
      print('채팅을 받아오겠음');

      dynamic responseData = jsonDecode(response.body)['data'];

      if (responseData is Map<String, dynamic>) {
        final replyList = responseData['chatList'] as List<dynamic>;
        for (final replyData in replyList) {
          final Chat newComment = Chat(
            uid: replyData['uid'] as String? ?? '', // 댓글의 텍스트 받아오기
            tid: replyData['tid'] as String? ?? '', // 댓글의 uid 받아오기
            chatRoomId: replyData['chatRoomId'] as String,
            chatId: replyData['chatId'] as String? ?? '',
            time: replyData['time'] as String, // liked 값 설정
            cText: replyData['cText'] as String? ?? '',       // uid의 프로필 사진 가져오기
            like: replyData['like'] as bool,       // uid의 프로필 사진 가져오기
          );

          setState(() {
            chats.add(newComment); // 댓글 받아와서 다 추가하기
          });
        }
      } else {
        print('Invalid response data');
      }
    } else {
      print(response.statusCode);
      throw Exception('채팅을 로드하는 데 실패했습니다');
    }
  }

  Future<void> addComment(String content, String tid) async {
    // 채팅 보내기

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final url = Uri.parse('$addressUrl/send_chat/');

    final response = await http.post(
      url,
      body: jsonEncode(<String, dynamic>{
        'uid': userProvider.uid,
        'tid': tid,
        'cText': content,
      }),
    );

    print(userProvider.uid);
    print(content);

    if (response.statusCode == 200) {}

    // final newComment = Comment(rText: content, isEditing: false);
    print('댓글 추가하기 성공쓰');
    print(content);
    chats.clear();
    fetchComments(widget.tid);
  }
}
