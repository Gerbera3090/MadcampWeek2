// home_page.dart
import 'package:flutter/material.dart';
import 'package:week2/main_view_model.dart';
import 'package:week2/main_page.dart';
import 'sign_up.dart';
import 'package:week2/kakao_login.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final viewModel = MainViewModel(KakaoLogin());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: '아이디',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: '비밀번호',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // 로그인 버튼이 눌렸을 때의 동작 구현
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainPage(),
                  ),
                );
              },
              child: const Text('로그인'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignUpPage(),
                  ),
                );
              },
              child: const Text('회원가입'),
            ),
            ElevatedButton(
              onPressed: () async {
                await viewModel.login();
                // 로그인 성공 시, 탭을 가진 메인 페이지로 이동
                if (viewModel.isLogined) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainPage(),
                    ),
                  );
                }
                setState(() {});
              },
              child: const Text('Login with kakao'),
            ),
            // ElevatedButton(
            //   onPressed: () async {
            //     await viewModel.logout();
            //     setState(() {});
            //   },
            //   child: const Text('Logout'),
            // ),
          ],
        ),
      ),
    );
  }
}