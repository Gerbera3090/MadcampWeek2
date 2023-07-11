import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:week2/main.dart';
import 'dart:convert';
import 'package:week2/profile.dart';
import 'user_provider.dart';
import 'package:provider/provider.dart';

class Comment {
  String rText;
  bool isEditing;
  String uid;
  int num_likes;
  String date;

  Comment(
      {required this.rText,
      this.isEditing = false,
      this.uid = '',
      this.num_likes = 0,
      this.date = ''});
}

class QuestionPage extends StatefulWidget {
  final String question;
  final int formattedIndex;

  const QuestionPage({
    Key? key,
    required this.question,
    required this.formattedIndex,
  }) : super(key: key);

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  List<Comment> comments = [];
  final commentController = TextEditingController();
  final editController = TextEditingController();
  bool hasCommented = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchComments(widget.formattedIndex); // 서버에서 댓글을 가져오는 함수 호출
    });
  }

  @override
  void dispose() {
    commentController.dispose();
    editController.dispose();
    super.dispose();
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('삭제 확인'),
        content: Text('해당 댓글을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('취소'),
          ),
          TextButton(
            onPressed: () {
              deleteComment(index); // 댓글 삭제 함수 호출
              Navigator.pop(context);
            },
            child: Text('삭제'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('# ${widget.formattedIndex}'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              widget.question,
              style: TextStyle(fontSize: 24),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                final bool isEditable =
                    comment.uid == userProvider.uid; // 사용자의 댓글인지 확인

                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Profile()),
                    );
                  },
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('assets/profile_image.png'),
                  ),
                  title: comment.isEditing
                      ? TextFormField(
                          initialValue: comment.rText,
                          onFieldSubmitted: (value) {
                            //  addComment(index);
                            setState(() {
                              comment.isEditing = false;
                            });
                          },
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  comment.uid,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(width: 10), // 왼쪽 마진 추가
                                Text(
                                  '${comment.date}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: const Color.fromARGB(
                                        255, 109, 109, 109),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4), // 위쪽 마진 추가
                            Text(comment.rText),
                            SizedBox(height: 4), // 위쪽 마진 추가
                            Text(
                              '좋아요 ${comment.num_likes} 개',
                              style: TextStyle(
                                fontSize: 10,
                                color: const Color.fromARGB(255, 109, 109, 109),
                              ),
                            ),
                          ],
                        ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isEditable) // 해당 사용자의 댓글이면 삭제 아이콘 표시
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _showDeleteDialog(index);
                          },
                        ),
                                          GestureDetector(
                    onTap: () {
                      // call like_question : qid uid 보내기
                     // like_question(index);
                      // refresh tab
                      // initState();
                    },
                    child: Icon(Icons.favorite_border
                      // liked[index] ? Icons.favorite : Icons.favorite_border,
                      // color: liked[index] ? Colors.red : Colors.grey,
                    ),
                  ),
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
                      labelText: '댓글 추가 및 수정',
                    ),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    final commentContent = commentController.text;
                    if (commentContent.isNotEmpty) {
                      addComment(
                          commentContent, widget.formattedIndex); // 댓글 추가 함수 호출
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

  Future<void> fetchComments(int index) async {
    // 댓글 받아오기
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final url = Uri.parse('$addressUrl/get_replies/');

    final response = await http.post(
      url,
      body: jsonEncode(<String, dynamic>{
        'qid': index,
        'uid': userProvider.uid,
      }),
    );

    if (response.statusCode == 200) {
      print('댓글을 받아오겠음');

      dynamic responseData = jsonDecode(response.body)['data'];

      if (responseData is Map<String, dynamic>) {
        final replyList = responseData['replyList'] as List<dynamic>;
        for (final replyData in replyList) {
          final Comment newComment = Comment(
              rText: replyData['rText'] as String? ?? '', // 댓글의 텍스트 받아오기
              isEditing: false,
              uid: replyData['uid'] as String? ?? '', // 댓글의 uid 받아오기
              num_likes: replyData['num_likes'] as int,
              date: replyData['date'] as String? ?? '');

          print('자 출력한다!!!');
          print(newComment.rText);

          setState(() {
            comments.add(newComment); // 댓글 받아와서 다 추가하기
          });
        }
      } else {
        print('Invalid response data');
      }
    } else {
      print(response.statusCode);
      throw Exception('댓글을 로드하는 데 실패했습니다');
    }
  }

  Future<void> addComment(String content, int index) async {
    // 댓글 추가하기  (post 사용: 서버에게 uid, pid, rText를 전달하고, 수정된 rText를 배열에 저장)

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final url = Uri.parse('$addressUrl/send_reply/');

    final response = await http.post(
      url,
      body: jsonEncode(<String, dynamic>{
        'qid': index,
        'uid': userProvider.uid,
        'rText': content,
      }),
    );

    print(index); // 여기서 인덱스는 그... 머지... 질문 번호임
    print(userProvider.uid);
    print(content);

    if (response.statusCode == 200) {}

    // final newComment = Comment(rText: content, isEditing: false);
    print('댓글 추가하기 성공쓰');
    print(index);
    comments.clear();
    fetchComments(widget.formattedIndex);
  }

  Future<void> deleteComment(int index) async {
    // 댓글 삭제하기

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final url = Uri.parse('$addressUrl/delete_reply/');

    final response = await http.post(
      url,
      body: jsonEncode(<String, dynamic>{
        'qid': widget.formattedIndex,
        'uid': userProvider.uid,
      }),
    );

    print(widget.formattedIndex);
    print(userProvider.uid);

    if (response.statusCode == 200) {
      print('댓글 삭제하기 성공쓰');
    }

    setState(() {
      comments.removeAt(index);
    });
  }

  void updateComment(int index, String content) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final url = Uri.parse('$addressUrl/send_reply/');

    final response = await http.post(
      url,
      body: jsonEncode(<String, dynamic>{
        'qid': widget.formattedIndex,
        'uid': userProvider.uid,
        'rText': content,
      }),
    );

    if (response.statusCode == 200) {
      // 서버에서 업데이트된 댓글 정보 받아오기
      final updatedComment = Comment(
        rText: content,
        isEditing: false,
        uid: userProvider.uid,
      );

      print(index);

      setState(() {
        comments[index] = updatedComment; // 댓글 정보 업데이트, 여기서 인덱스는 이미 달린 댓글의 인덱스임
      });
    }
  }
}
