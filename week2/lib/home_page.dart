import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'main_view_model.dart';
import 'main_page.dart';
import 'sign_up.dart';
import 'kakao_login.dart';
import 'user_provider.dart';
import 'main.dart';
import 'dart:typed_data';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final MainViewModel viewModel = MainViewModel(KakaoLogin());

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

Future<bool> login(UserProvider userProvider) async {
  final uid = _usernameController.text;
  final password = _passwordController.text;

  final url = Uri.parse('$addressUrl/login/');

  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(<String, String>{
      'uid': uid,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    final bool loginSuccess = responseData['result'] as bool;

    if (loginSuccess) {
      final String nickName = responseData['nickName'] as String;
      userProvider.setNickName(nickName); // 로그인 성공 시, UserProvider에 사용자 정보 설정
      final String uid = responseData['uid'] as String;
      userProvider.setUid(uid); // 로그인 성공 시, UserProvider에 사용자 정보 설정
      final String password = responseData['password'] as String;
      userProvider.setPassword(password); // 로그인 성공 시, UserProvider에 사용자 정보 설정
      final String name = responseData['name'] as String;
      userProvider.setName(name); // 로그인 성공 시, UserProvider에 사용자 정보 설정
      final String univ = responseData['univ'] as String;
      userProvider.setUniv(univ); // 로그인 성공 시, UserProvider에 사용자 정보 설정
      final String region = responseData['region'] as String;
      userProvider.setRegion(region); // 로그인 성공 시, UserProvider에 사용자 정보 설정
      final String phoneNumber = responseData['phoneNumber'] as String;
      userProvider.setPhoneNumber(phoneNumber); // 로그인 성공 시, UserProvider에 사용자 정보 설정
      final photo = responseData['profile_img'];
      userProvider.setPhoto(photo);
    }

    return loginSuccess;
  } else {
    print('Request failed with status: ${response.statusCode}');
    return false;
  }
}


  void _handleLogin(BuildContext context, UserProvider userProvider) async {
    final bool isLoggedIn = await login(userProvider);

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainPage(),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('로그인 실패'),
          content: Text('아이디 또는 비밀번호가 잘못되었습니다.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('확인'),
            ),
          ],
        ),
      );
    }
  }

  void _handleDeveloperButton() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        leading: Image.asset('assets/qfeed_label.png'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: '아이디',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: '비밀번호',
              ),
            ),
            ElevatedButton(
              onPressed: () => _handleLogin(context, userProvider),
              child: const Text('로그인'),
            ),
            // ElevatedButton(
            //   onPressed: _handleDeveloperButton,
            //   child: const Text('개발자 버튼'),
            // ),
            ElevatedButton(
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
            // ElevatedButton(
            //   onPressed: () async {
            //     await viewModel.login();
            //     if (viewModel.isLogined) {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => MainPage(),
            //         ),
            //       );
            //     }
            //     setState(() {});
            //   },
            //   child: const Text('Login with kakao'),
            // ),
          ],
        ),
      ),
    );
  }
}
