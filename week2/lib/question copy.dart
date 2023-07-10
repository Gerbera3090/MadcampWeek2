import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:week2/profile.dart';

class Comment {
  String content;
  bool isEditing;

  Comment({required this.content, this.isEditing = false});
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

  @override
  void initState() {
    super.initState();
    fetchComments(); // 서버에서 댓글을 가져오는 함수 호출
  }

  @override
  void dispose() {
    commentController.dispose();
    editController.dispose();
    super.dispose();
  }

  void _showEditDialog(int index) {
    editController.text = comments[index].content;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('댓글 수정'),
        content: TextFormField(
          controller: editController,
          decoration: InputDecoration(
            labelText: '댓글',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('취소'),
          ),
          TextButton(
            onPressed: () {
              updateComment(index, editController.text); // 댓글 수정 함수 호출
              Navigator.pop(context);
            },
            child: Text('완료'),
          ),
        ],
      ),
    );
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
                          initialValue: comment.content,
                          onFieldSubmitted: (value) {
                            updateComment(index, value); // 댓글 수정 함수 호출
                            setState(() {
                              comment.isEditing = false;
                            });
                          },
                        )
                      : Text(comment.content),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          setState(() {
                            comment.isEditing = true;
                          });
                          _showEditDialog(index);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _showDeleteDialog(index);
                        },
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
                      labelText: '댓글 추가',
                    ),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    final commentContent = commentController.text;
                    if (commentContent.isNotEmpty) {
                      addComment(commentContent); // 댓글 추가 함수 호출
                      commentController.clear();
                    }
                  },
                  child: Text('댓글 추가'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> fetchComments() async {
    // 댓글을 가져오는 비동기 함수
    // 서버로부터 댓글 리스트를 받아온 후 상태를 업데이트합니다.
    final url = Uri.parse(
        'https://a800-192-249-19-234.ngrok-free.app/mainapp/get_replies/');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);

      final List<Comment> fetchedComments = responseData.map((data) {
        return Comment(
          content: data['content'] as String,
          isEditing: false,
        );
      }).toList();

      setState(() {
        comments = fetchedComments;
      });
    } else {
      throw Exception('Failed to fetch comments');
    }
  }

  Future<void> addComment(String content) async {
    // 댓글을 추가하는 비동기 함수
    // 서버에 새로운 댓글을 전달하고 성공적으로 처리되면 상태를 업데이트합니다.
    final url = Uri.parse(
        'https://a800-192-249-19-234.ngrok-free.app/mainapp/get_replies/');

    final response = await http.post(
      url,
      body: jsonEncode(<String, String>{
        'content': content,
      }),
    );

    if (response.statusCode == 201) {
      final dynamic responseData = jsonDecode(response.body);

      final Comment newComment = Comment(
        content: responseData['content'] as String,
        isEditing: false,
      );

      setState(() {
        comments.add(newComment);
      });
    } else {
      print(response.statusCode);
      throw Exception('Failed to add comment');
    }
  }

  Future<void> updateComment(int index, String content) async {
    final url = Uri.parse(
        'https://a800-192-249-19-234.ngrok-free.app/mainapp/get_replies/');

    final response = await http.post(
      url,
      body: jsonEncode(<String, dynamic>{
        'index': index,
        'content': content,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        comments[index].content = content;
        comments[index].isEditing = false;
      });
    } else {
      throw Exception('Failed to update comment');
    }
  }

  Future<void> deleteComment(int index) async {
    final url = Uri.parse(
        'https://a800-192-249-19-234.ngrok-free.app/mainapp/get_replies/');

    final response = await http.post(
      url,
      body: jsonEncode(<String, dynamic>{
        'index': index,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        comments.removeAt(index);
      });
    } else {
      throw Exception('Failed to delete comment');
    }
  }
}
