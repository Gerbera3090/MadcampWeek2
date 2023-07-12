import 'package:flutter/material.dart';
import 'package:week2/main_page.dart';
import 'package:http/http.dart' as http;
import 'package:week2/user_provider.dart';
import 'dart:convert';
import 'main.dart';
import 'user_provider.dart';
import 'package:provider/provider.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  List<String> region = [
    '서울',
    '경기',
    '부산',
    '대전',
    '인천',
    '대구',
    '완주',
    '경상',
  ];

  List<bool> isRegionSelected = [];

  List<String> univ = [
    '고려대',
    '카이스트',
    '한양대',
    '유니스트',
    '포스텍',
    '부산대',
    '숙명여대',
  ];

  List<bool> isUnivSelected = [];

  @override
  void initState() {
    super.initState();
    isRegionSelected = List.filled(region.length, false);
    isUnivSelected = List.filled(univ.length, false);
    fetchDataFromServer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('거주지 선택', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(region.length, (index) {
                  return FilterButton(
                    label: region[index],
                    isSelected: isRegionSelected[index],
                    onTap: () {
                      setState(() {
                        isRegionSelected[index] = !isRegionSelected[index];
                      });
                    },
                  );
                }),
              ),
              SizedBox(height: 16),
              Text('학교 선택', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(univ.length, (index) {
                  return FilterButton(
                    label: univ[index],
                    isSelected: isUnivSelected[index],
                    onTap: () {
                      setState(() {
                        isUnivSelected[index] = !isUnivSelected[index];
                      });
                    },
                  );
                }),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  bool isRegionSelected = this.isRegionSelected.contains(true);
                  bool isUnivSelected = this.isUnivSelected.contains(true);

                  if (isRegionSelected && isUnivSelected) {
                    sendDataToServer();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainPage(),
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('선택 오류'),
                        content: Text('거주지와 학교를 모두 선택해주세요.'),
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

  void fetchDataFromServer() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // 서버 URL 설정
    String url = '${addressUrl}/get_filter/';

    try {
      // POST 요청 보내기
      http.Response response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'uid': userProvider.uid}),
      );

      // 응답 확인
      if (response.statusCode == 200) {
        print('200');
        // 성공적으로 데이터 받아옴
        Map<String, dynamic> responseData = jsonDecode(response.body)['data'];
        List<String>? regionData = responseData['region'] != null
            ? List<String>.from(responseData['region'])
            : null;
        List<String>? univData = responseData['univ'] != null
            ? List<String>.from(responseData['univ'])
            : null;

        if (regionData != null) {
          for (int i = 0; i < region.length; i++) {
            if (regionData.contains(region[i])) {
              setState(() {
                isRegionSelected[i] = true;
              });
            }
          }
        } else
        if (univData != null) {
          for (int i = 0; i < univ.length; i++) {
            if (univData.contains(univ[i])) {
              setState(() {
                isUnivSelected[i] = true;
              });
            }
          }
        }
      } else {
        // 요청 실패
        print('Failed to fetch data');
      }
    } catch (e) {
      // 오류 처리
      print('Error: $e');
    }
  }

  void sendDataToServer() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    List<String> selectedRegions = [];
    for (int i = 0; i < region.length; i++) {
      if (isRegionSelected[i]) {
        selectedRegions.add(region[i]);
      }
    }

    List<String> selectedUnivs = [];
    for (int i = 0; i < univ.length; i++) {
      if (isUnivSelected[i]) {
        selectedUnivs.add(univ[i]);
      }
    }

    Map<String, dynamic> requestData = {
      'uid': userProvider.uid,
      'region': selectedRegions,
      'univ': selectedUnivs,
    };

    // 데이터를 JSON 형태로 변환
    String jsonBody = jsonEncode(requestData);

    // 서버 URL 설정
    String url = '${addressUrl}/edit_filter/';

    try {
      // POST 요청 보내기
      http.Response response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonBody,
      );

      // 응답 확인
      if (response.statusCode == 200) {
        // 성공적으로 전송됨
        print('Data sent successfully');
      } else {
        // 요청 실패
        print('Failed to send data');
      }
    } catch (e) {
      // 오류 처리
      print('Error: $e');
    }
  }
}

class FilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterButton({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          primary: isSelected ? Colors.blue : Colors.grey,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: Text(
              label,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
