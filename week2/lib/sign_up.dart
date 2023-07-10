// sign_up_page.dart
import 'package:flutter/material.dart';
import 'package:week2/filter.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  String profile = '';
  String nickname = '';
  String fullName = '';
  String? selectedSchool;
  String? selectedRegion;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('프로필 설정', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    profile = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: '프로필 URL',
                ),
              ),
              SizedBox(height: 16),
              Text('닉네임 설정', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    nickname = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: '닉네임',
                ),
              ),
              SizedBox(height: 16),
              Text('ID 설정', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    nickname = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'ID',
                ),
              ),
              SizedBox(height: 16),
              Text('PASSWORD 설정', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Stack(
                alignment: Alignment.centerRight,
                children: [
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        // nickname = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'PASSWORD',
                    ),
                    obscureText: !_isPasswordVisible, // 입력된 문자를 가려서 보이지 않게 함
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
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
              Text('PASSWORD 확인', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Stack(
                alignment: Alignment.centerRight,
                children: [
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        // nickname = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'PASSWORD',
                    ),
                    obscureText:
                        !_isConfirmPasswordVisible, // 입력된 문자를 가려서 보이지 않게 함
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                    icon: Icon(
                      _isConfirmPasswordVisible
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
                onChanged: (value) {
                  setState(() {
                    fullName = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: '실명',
                ),
              ),
              SizedBox(height: 16),
              Text('학교 선택', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedSchool,
                onChanged: (value) {
                  setState(() {
                    selectedSchool = value;
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
                value: selectedRegion,
                onChanged: (value) {
                  setState(() {
                    selectedRegion = value;
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
                  // 다른 지역들도 추가해주세요
                ],
                decoration: InputDecoration(
                  labelText: '거주지',
                ),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (profile.isNotEmpty &&
                      nickname.isNotEmpty &&
                      fullName.isNotEmpty &&
                      selectedSchool != null &&
                      selectedRegion != null) {
                    // 다음 페이지로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FilterPage(),
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('입력 오류'),
                        content: Text('모든 정보를 입력해주세요.'),
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
                },
                child: const Text('완료'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
