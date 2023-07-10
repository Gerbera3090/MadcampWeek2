import 'package:flutter/material.dart';
import 'package:week2/question.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'user_provider.dart';
import 'package:provider/provider.dart';

class Tab1Page extends StatefulWidget {
  Tab1Page({Key? key}) : super(key: key);

  @override
  _Tab1PageState createState() => _Tab1PageState();
}

class _Tab1PageState extends State<Tab1Page> {
  List<String> questionList = [];
  List<bool> liked = [];

  @override
  Widget build(BuildContext context) {
    // final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: ListView.builder(
        itemCount: questionList.length,
        itemBuilder: (context, index) {
          final question = questionList[index];
          final formattedIndex = index + 1;

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuestionPage(
                    question: question,
                    formattedIndex: formattedIndex,
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
                  Text('＃${formattedIndex.toString()}'),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(question),
                  ),
                  GestureDetector(
                    onTap: () {
                      // call like_question : qid uid 보내기
                      like_question(index);
                      // refresh tab
                      // initState();
                    },
                    child: Icon(
                      liked[index] ? Icons.favorite : Icons.favorite_border,
                      color: liked[index] ? Colors.red : Colors.grey,
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
  @override
  void initState() {
    super.initState();

    print("새로고침!!!!!");

    // 서버에서 질문을 받아오는 비동기 함수를 호출하고 받아온 질문을 questionList에 추가합니다.
    fetchQuestions().then((questions) {
      final List<String> questionTextList =
          questions.map((question) => question['qText'] as String).toList();
      final List<bool> questionLikedList =
          questions.map((question) => question['liked'] as bool).toList();
      setState(() {
        questionList.clear();
        liked.clear();
        questionList.addAll(questionTextList);
        liked.addAll(questionLikedList);
      });
    });
  }

Future<void> like_question(int index) async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  final uid = userProvider.uid;
  final questionId = index+1;

  final url = Uri.parse('https://a800-192-249-19-234.ngrok-free.app/mainapp/like_question/');

  final response = await http.post(
    url,
    body: jsonEncode(<String, dynamic>{
      'uid': uid,
      'qid': questionId,
    }),
  );

  if (response.statusCode == 200) {
    print(response.statusCode);
    final responseData = jsonDecode(response.body);
    if(responseData['result'] as bool){
      setState(() {
        liked[index] = !liked[index];
      });
    }
    // 성공적으로 데이터를 서버에 보냈을 때 처리할 로직
  } else {
    print(response.statusCode);
    throw Exception('Failed to like the question');
  }
}

  Future<List<Map<String, dynamic>>> fetchQuestions() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final uid = userProvider.uid;

    final url = Uri.parse(
        'https://a800-192-249-19-234.ngrok-free.app/mainapp/get_questions/');

    final response = await http.post(
      url,
      body: jsonEncode(<String, String>{
        'uid': uid,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final List<dynamic> questionsData = responseData['data'];

      final List<Map<String, dynamic>> questions = questionsData.map((data) {
        return {
          'qText': data['qText'] as String,
          'qid': data['qid'] as int,
          'num_replies': data['num_replies'] as int,
          'num_likedUsers': data['num_likedUsers'] as int,
          'replied': data['replied'] as bool,
          'liked': data['liked'] as bool,
        };
      }).toList();

      return questions;
      
    } else {
      print(response.statusCode);
      throw Exception('Failed to fetch questions');
    }
  }
}
