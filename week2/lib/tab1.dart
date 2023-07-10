import 'package:flutter/material.dart';
import 'package:week2/question.dart';

class Tab1Page extends StatefulWidget {
  Tab1Page({Key? key}) : super(key: key);

  @override
  _Tab1PageState createState() => _Tab1PageState();
}

class _Tab1PageState extends State<Tab1Page> {
  List<String> questionList = [
    '질문 1',
    '질문 2',
    '질문 3',
    '질문 4',
    '질문 5',
    '질문 6',
    '질문 7',
    '질문 8',
    '질문 9',
    '질문 10',
    '질문 11',
    '질문 12',
    '질문 13',
    '질문 14',
    '질문 15',
  ];

  @override
  Widget build(BuildContext context) {
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
    // 여기서 서버에서 질문을 받아와서 questionList에 추가하는 로직을 작성합니다.
    // 예를 들어, Future나 Stream을 사용하여 비동기로 질문을 받아올 수 있습니다.
    // 받아온 질문을 questionList에 추가하고 setState를 호출하여 화면을 업데이트합니다.
    // 아래는 가짜 데이터로 예시를 보여드립니다.
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        questionList.add('새로운 질문 1');
        questionList.add('새로운 질문 2');
      });
    });
  }
}
