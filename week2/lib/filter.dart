import 'package:flutter/material.dart';
import 'package:week2/main_page.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  bool isSeoulSelected = false;
  bool isGyeonggiSelected = false;
  bool isBusanSelected = false;
  bool isDaejeonSelected = false;
  bool isincheonSelected = false;
  bool isDaeguSelected = false;
  bool iswanjuSelected = false;

  bool isKoreaSelected = false;
  bool isKAISTSelected = false;
  bool isHanyangSelected = false;
  bool isUNISTSelected = false;
  bool isPostechselected = false;
  bool isPusanSelected = false;
  bool isSookmyungselected = false;

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
                children: [
                  FilterButton(
                    label: '서울',
                    isSelected: isSeoulSelected,
                    onTap: () {
                      setState(() {
                        isSeoulSelected = !isSeoulSelected;
                      });
                    },
                  ),
                  FilterButton(
                    label: '경기',
                    isSelected: isGyeonggiSelected,
                    onTap: () {
                      setState(() {
                        isGyeonggiSelected = !isGyeonggiSelected;
                      });
                    },
                  ),
                  FilterButton(
                    label: '부산',
                    isSelected: isBusanSelected,
                    onTap: () {
                      setState(() {
                        isBusanSelected = !isBusanSelected;
                      });
                    },
                  ),
                  FilterButton(
                    label: '대전',
                    isSelected: isDaejeonSelected,
                    onTap: () {
                      setState(() {
                        isDaejeonSelected = !isDaejeonSelected;
                      });
                    },
                  ),
                  FilterButton(
                    label: '완주',
                    isSelected: iswanjuSelected,
                    onTap: () {
                      setState(() {
                        iswanjuSelected = !iswanjuSelected;
                      });
                    },
                  ),
                  FilterButton(
                    label: '대구',
                    isSelected: isDaeguSelected,
                    onTap: () {
                      setState(() {
                        isDaeguSelected = !isDaeguSelected;
                      });
                    },
                  ),
                  FilterButton(
                    label: '인천',
                    isSelected: isincheonSelected,
                    onTap: () {
                      setState(() {
                        isincheonSelected = !isincheonSelected;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text('학교 선택', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilterButton(
                    label: '고려대',
                    isSelected: isKoreaSelected,
                    onTap: () {
                      setState(() {
                        isKoreaSelected = !isKoreaSelected;
                      });
                    },
                  ),
                  FilterButton(
                    label: '카이스트',
                    isSelected: isKAISTSelected,
                    onTap: () {
                      setState(() {
                        isKAISTSelected = !isKAISTSelected;
                      });
                    },
                  ),
                  FilterButton(
                    label: '한양대',
                    isSelected: isHanyangSelected,
                    onTap: () {
                      setState(() {
                        isHanyangSelected = !isHanyangSelected;
                      });
                    },
                  ),
                  FilterButton(
                    label: '유니스트',
                    isSelected: isUNISTSelected,
                    onTap: () {
                      setState(() {
                        isUNISTSelected = !isUNISTSelected;
                      });
                    },
                  ),
                  FilterButton(
                    label: '포스텍',
                    isSelected: isPostechselected,
                    onTap: () {
                      setState(() {
                        isPostechselected = !isPostechselected;
                      });
                    },
                  ),
                  FilterButton(
                    label: '부산대',
                    isSelected: isPusanSelected,
                    onTap: () {
                      setState(() {
                        isPusanSelected = !isPusanSelected;
                      });
                    },
                  ),
                  FilterButton(
                    label: '숙명여대',
                    isSelected: isSookmyungselected,
                    onTap: () {
                      setState(() {
                        isSookmyungselected = !isSookmyungselected;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if ((isSeoulSelected ||
                          isGyeonggiSelected ||
                          isBusanSelected ||
                          isDaejeonSelected ||
                          isincheonSelected ||
                          isDaeguSelected ||
                          iswanjuSelected) &&
                      (isKoreaSelected ||
                          isKAISTSelected ||
                          isHanyangSelected ||
                          isUNISTSelected ||
                          isPostechselected ||
                          isPusanSelected ||
                          isSookmyungselected)) {
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
