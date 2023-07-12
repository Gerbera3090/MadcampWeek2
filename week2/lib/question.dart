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
  bool liked;
  String photo_img;
  String nickName;

  Comment(
      {required this.rText,
      this.isEditing = false,
      this.uid = '',
      this.num_likes = 0,
      this.date = '',
      this.liked = false,
      this.photo_img = '',
      this.nickName = '',
      });
}

class QuestionPage extends StatefulWidget {
  final String question;
  final int formattedIndex;
  final int numLikedUsers;

  const QuestionPage({
    Key? key,
    required this.question,
    required this.formattedIndex,
    required this.numLikedUsers,
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
        leading: Image.asset('assets/qfeed_label.png'),
      ),
      body: Column(
        children: [
          Container(
            child: SizedBox(
              width: double.infinity, // 부모의 가로 크기에 맞추기 위해
              child: Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  //border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0xFFFFD6D6),
                ),
                child: Text(
                  widget.question,
                  style: TextStyle(fontSize: 24),
                  textAlign: TextAlign.center, // 텍스트를 가운데 정렬합니다.
                  softWrap: true,   
                  overflow: TextOverflow.visible,
                ),
              ),
            ),
          ),
          Row(
            children: [
              SizedBox(width: 16),
              Icon(
                Icons.favorite,
                color: Colors.red,
              ),
              SizedBox(width: 4),
              Text(
                '${widget.numLikedUsers} 개', // 좋아요 개수
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              SizedBox(width: 16),
              Icon(
                Icons.comment,
                color: Colors.grey,
              ),
              SizedBox(width: 4),
              Text(
                '${comments.length} 개',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
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
                      MaterialPageRoute(
                          builder: (context) => Profile(nickName: comment.nickName, uid: comment.uid)),

                    );
                  },
                  leading: CircleAvatar(
                      backgroundImage: MemoryImage(userProvider.photo!)
                          as ImageProvider<Object>?),
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
                                  comment.nickName,
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
                          likeComment(index);
                        },
                        child: Icon(
                          comment.liked
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: comment.liked ? Colors.red : Colors.grey,
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

  Future<void> likeComment(int index) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final url = Uri.parse('$addressUrl/like_reply/');

    final response = await http.post(
      url,
      body: jsonEncode(<String, dynamic>{
        'uid': userProvider.uid,
        'qid': widget.formattedIndex,
        'tid': comments[index].uid,
      }),
    );

    if (response.statusCode == 200) {
      print(response.statusCode);

      final responseData = jsonDecode(response.body);
      final updatedNumLikes = responseData['num_likes'] as int;
      // final liked = responseData['liked'] as bool;

      setState(() {
        comments[index].num_likes = updatedNumLikes;
        comments[index].liked = !comments[index].liked;
      });
    } else {
      print(response.statusCode);
      throw Exception('Failed to like comment');
    }
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
            date: replyData['date'] as String? ?? '',
            liked: replyData['liked'] as bool, // liked 값 설정
            photo_img: replyData['photo_img'] as String? ?? '',       // uid의 프로필 사진 가져오기
            nickName: replyData['nickName'] as String? ?? '',       // uid의 프로필 사진 가져오기
          );

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
