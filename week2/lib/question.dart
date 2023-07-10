import 'package:flutter/material.dart';

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
              setState(() {
                comments[index].content = editController.text;
                comments[index].isEditing = false;
              });
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
              setState(() {
                comments.removeAt(index);
              });
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
                  title: comment.isEditing
                      ? TextFormField(
                          initialValue: comment.content,
                          onFieldSubmitted: (value) {
                            setState(() {
                              comment.content = value;
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
                      final comment = Comment(content: commentContent);
                      setState(() {
                        comments.add(comment);
                      });
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
}
