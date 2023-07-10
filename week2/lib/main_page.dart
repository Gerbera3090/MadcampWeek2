// main_page.dart
import 'package:flutter/material.dart';
import 'package:week2/tab1.dart';
import 'package:week2/tab2.dart';
import 'package:week2/tab3.dart';


class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('QFEED'),
            bottom: TabBar(
              indicatorColor: Colors.blue,
              tabs: [
                Tab(icon: Icon(Icons.question_mark)),
                Tab(icon: Icon(Icons.chat_bubble_outline)),
                Tab(icon: Icon(Icons.perm_identity)),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Tab1Page(), // 첫 번째 탭을 Tab1Page로 대체
              Tab2Page(),
              Tab3Page(),
            ],
          ),
        ),
      ),
    );
  }
}