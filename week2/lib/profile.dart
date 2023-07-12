import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'profile_setting.dart';
import 'dart:io';
import 'main.dart';

class Answer {
  final int qid;
  final String qText;
  final String rText;

  Answer({
    required this.qid,
    required this.qText,
    required this.rText,
  });
}

class Profile extends StatefulWidget {
  final String nickName;
  final String uid;

  Profile({required this.nickName, required this.uid});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? _selectedImage;
  List<Answer> answerList = []; // 댓글 단 게시물 리스트

  @override
  void initState() {
    super.initState();
    fetchPosts(); // 서버에서 댓글 단 게시물을 받아오는 함수 호출
    print('프로필 들어옴');
  }

  Future<void> fetchPosts() async {
    print('게시글 불러올 거임');

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    // final password = userProvider.password;

    final url = Uri.parse('$addressUrl/get_profile/');

    final response = await http.post(
      url,
      body: jsonEncode(<String, String>{
        'uid': userProvider.uid,
        'tid': widget.uid,
      }),
    );

    if (response.statusCode == 200) {
      print('받아오겠음');

      final responseData = jsonDecode(response.body);
      final postData = responseData['answerList'];

      if (postData != null && postData is List<dynamic>) {
        // 이게 안 됨,.,. 데이터 형식이???
        print('받아오기 시작(데이터 형식 맞음)');
        final List<Answer> posts = postData.map<Answer>((data) {
          return Answer(
            qid: data['qid'] as int,
            qText: data['qText'] as String,
            rText: data['rText'] as String,
          );
        }).toList();

        print('잘 받아왓다');

        setState(() {
          answerList.clear();
          answerList.addAll(posts);
        });
      }
      print('널이거나 데이터 형식 안 맞거나');
    } else {
      print(response.statusCode);
      throw Exception('Failed to fetch user posts');
    }
  }

  // 나머지 코드 생략...

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileSetting()),
                );
              },
              child: CircleAvatar(
                radius: 64,
                backgroundImage:
                    MemoryImage(userProvider.photo!) as ImageProvider<Object>?,
                // 프로필 사진이 없으면 파란색으로 기본 프로필
              ),
            ),
            SizedBox(height: 16),
            Text(
              widget.nickName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: answerList.length,
                itemBuilder: (context, index) {
                  final post = answerList[index];

                  return Container(
                    padding: const EdgeInsets.all(16),
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('# ${post.qid}'),
                        Text('Q. ${post.qText}'),
                        Text('A. ${post.rText}'),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          sendDataToServer(userProvider.uid, widget.uid);
        },
        child: Icon(Icons.chat),
      ),
    );
  }

  void sendDataToServer(String uid, String tid) async {
    final url = Uri.parse('$addressUrl/send_chatroom/');

    try {
      final response = await http.post(
        url,
        body: jsonEncode(<String, String>{
          'uid': uid,
          'tid': tid,
        }),
      );

      if (response.statusCode == 200) {
        print('Data sent successfully');
      } else {
        print('Failed to send data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
