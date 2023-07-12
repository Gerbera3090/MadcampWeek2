import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:week2/home_page.dart';
import 'main.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  String? _selectedSchool;
  String? _selectedRegion;
  bool _isPasswordVisible = false;

  Future<void> signUp() async {
    // 완료 버튼이 눌렸을 때, 서버에 정보를 보냄
    final nickname = _nicknameController.text;
    final id = _idController.text;
    final password = _passwordController.text;
    final fullName = _fullNameController.text;
    final school = _selectedSchool;
    final region = _selectedRegion;
    final phoneNumber = _phoneNumberController.text;

    if (nickname.isEmpty ||
        id.isEmpty ||
        password.isEmpty ||
        fullName.isEmpty ||
        school == null ||
        region == null ||
        phoneNumber.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('회원가입 실패'),
          content: Text('회원가입 정보를 모두 입력해주세요.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('확인'),
            ),
          ],
        ),
      );
      return;
    }

    final url = Uri.parse(
        '$addressUrl/signup/'); // 회원가입 엔드포인트 URL (수정해야 함)

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'nickName': nickname,
        'uid': id,
        'password': password,
        'name': fullName,
        'univ': school,
        'region': region,
        'phoneNumber': phoneNumber, // 휴대폰 번호 추가
      }),
    );

    if (response.statusCode == 200) {
      
      // 회원가입 요청이 성공적으로 처리되었을 때의 처리
      final responseData = jsonDecode(response.body);
      final bool signUpSuccess = responseData; // 서버에서 응답한 회원가입 성공 여부

      if (signUpSuccess) {
        // 회원가입 성공
        print('Request SUCCESS!: ${response.statusCode}');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('회원가입 성공'),
            content: Text('회원가입이 성공적으로 완료되었습니다.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    // 회원가입 완료 후 main_page.dart로 이동
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(title: 'Home Page'),
                    ),
                  );
                },
                child: Text('확인'),
              ),
            ],
          ),
        );
      } else {
        // 회원가입 실패
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('회원가입 실패'),
            content: Text('회원가입에 실패했습니다. 다시 시도해주세요.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MyHomePage(title: 'QFEED'), // MyHomePage로 이동
                    ),
                  );
                },
                child: Text('확인'),
              ),
            ],
          ),
        );
      }
    } else {
      // 회원가입 요청이 실패했을 때의 처리
      print('Request failed with status: ${response.statusCode}');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('오류'),
          content: Text('회원가입 요청에 실패했습니다. 다시 시도해주세요.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('확인'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
        leading: Image.asset('assets/qfeed_label.png'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // 위젯들을 추가하고 설정합니다.
              SizedBox(height: 16),
              Text('닉네임 설정', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              TextFormField(
                controller: _nicknameController,
                onChanged: (value) {
                  // 닉네임 변경 시 상태 업데이트
                },
                decoration: InputDecoration(
                  labelText: '닉네임',
                ),
                textInputAction: TextInputAction.next, // 키보드 액션을 "다음"으로 설정
                onEditingComplete: () =>
                    FocusScope.of(context).nextFocus(), // 포커스를 다음으로 이동
              ),
              SizedBox(height: 16),
              SizedBox(height: 16),
              Text('ID 설정', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              TextFormField(
                controller: _idController,
                onChanged: (value) {
                  // ID 변경 시 상태 업데이트
                },
                decoration: InputDecoration(
                  labelText: 'ID',
                ),
                textInputAction: TextInputAction.next, // 키보드 액션을 "다음"으로 설정
                onEditingComplete: () =>
                    FocusScope.of(context).nextFocus(), // 포커스를 다음으로 이동
              ),
              SizedBox(height: 16),
              Text('PASSWORD 설정', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Stack(
                alignment: Alignment.centerRight,
                children: [
                  TextFormField(
                    controller: _passwordController,
                    // ...
                    obscureText: !_isPasswordVisible, // 입력된 문자를 가려서 보이지 않게 함
                    decoration: InputDecoration(
                      labelText: 'PASSWORD',
                    ),
                    textInputAction: TextInputAction.next, // 키보드 액션을 "다음"으로 설정
                    onEditingComplete: () =>
                        FocusScope.of(context).nextFocus(), // 포커스를 다음으로 이동
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible =
                            !_isPasswordVisible; // 눈 모양 아이콘 클릭 시 상태 변경
                      });
                    },
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text('실명 입력', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              TextFormField(
                controller: _fullNameController,
                onChanged: (value) {
                  // 실명 변경 시 상태 업데이트
                },
                decoration: InputDecoration(
                  labelText: '실명',
                ),
                textInputAction: TextInputAction.next, // 키보드 액션을 "다음"으로 설정
                onEditingComplete: () =>
                    FocusScope.of(context).nextFocus(), // 포커스를 다음으로 이동
              ),
              SizedBox(height: 16),

              Text('휴대폰 번호 입력', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _phoneNumberController,
                onChanged: (value) {
                  // 휴대폰 번호 변경 시 상태 업데이트
                },
                decoration: InputDecoration(
                  labelText: '휴대폰 번호',
                ),
                textInputAction: TextInputAction.next, // 키보드 액션을 "다음"으로 설정
                onEditingComplete: () =>
                    FocusScope.of(context).nextFocus(), // 포커스를 다음으로 이동
              ),
              SizedBox(height: 16),
              Text('학교 선택', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedSchool,
                onChanged: (value) {
                  setState(() {
                    _selectedSchool = value; // 선택된 학교 업데이트
                  });
                },
                items: [
                  DropdownMenuItem(value: '고려대', child: Text('고려대')),
                  DropdownMenuItem(value: '카이스트', child: Text('카이스트')),
                  DropdownMenuItem(value: '한양대', child: Text('한양대')),
                  DropdownMenuItem(value: '유니스트', child: Text('유니스트')),
                  DropdownMenuItem(value: '포스텍', child: Text('포스텍')),
                  DropdownMenuItem(value: '부산대', child: Text('부산대')),
                  DropdownMenuItem(value: '숙명여대', child: Text('숙명여대')),
                ],
                decoration: InputDecoration(
                  labelText: '학교',
                ),
              ),
              SizedBox(height: 16),
              Text('거주지 선택', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedRegion,
                onChanged: (value) {
                  // 거주지 선택 시 상태 업데이트
                  setState(() {
                    _selectedRegion = value; // 선택된 학교 업데이트
                  });
                },
                items: [
                  DropdownMenuItem(value: '서울', child: Text('서울')),
                  DropdownMenuItem(value: '경기', child: Text('경기')),
                  DropdownMenuItem(value: '부산', child: Text('부산')),
                  DropdownMenuItem(value: '대전', child: Text('대전')),
                  DropdownMenuItem(value: '완주', child: Text('완주')),
                  DropdownMenuItem(value: '대구', child: Text('대구')),
                  DropdownMenuItem(value: '인천', child: Text('인천')),
                  DropdownMenuItem(value: '광주', child: Text('광주')),
                ],
                decoration: InputDecoration(
                  labelText: '거주지',
                ),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // 회원가입 버튼이 눌렸을 때의 동작
                  signUp();
                },
                child: const Text('회원가입'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
