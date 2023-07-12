import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'user_provider.dart';
import 'package:provider/provider.dart';
import 'filter.dart';
import 'home_page.dart';

class ProfileSetting extends StatefulWidget {
  @override
  ProfileSettingStage createState() => ProfileSettingStage();
}

class ProfileSettingStage extends State<ProfileSetting> {
  File? _selectedImage;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: source);

    setState(() {
      if (pickedImage != null) {
        _selectedImage = File(pickedImage.path);
      }
    });
  }

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _selectedImage = File(pickedImage.path);
      }
    });
  }

  Future<void> _pickImageFromCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedImage != null) {
        _selectedImage = File(pickedImage.path);
      }
    });
  }

  Future<void> _showOptionsDialog() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('프로필 사진 변경'),
        content: Text('수정 또는 삭제할까요?'),
        actions: [
          TextButton(
            onPressed: () {
              _showImagePickerDialog();
              Navigator.pop(context);
            },
            child: Text('수정'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedImage = null;
              });
              Navigator.pop(context);
            },
            child: Text('삭제'),
          ),
        ],
      ),
    );
  }

  Future<void> _showImagePickerDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('사진 가져오기'),
        content: Text('사진을 가져올 방법을 선택하세요.'),
        actions: [
          TextButton(
            onPressed: () {
              _pickImageFromGallery();
              Navigator.pop(context);
            },
            child: Text('갤러리'),
          ),
          TextButton(
            onPressed: () {
              _pickImageFromCamera();
              Navigator.pop(context);
            },
            child: Text('카메라'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                _showOptionsDialog();
              },
              child: CircleAvatar(
                  radius: 64,
                  backgroundImage:
                      MemoryImage(userProvider.photo!) as ImageProvider<Object>?),
            ),
            SizedBox(height: 16),
            Text(
              userProvider.nickName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              userProvider.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              userProvider.univ,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              userProvider.region,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              userProvider.phoneNumber,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FilterPage(),
                  ),
                );
              },
              child: Text('필터 설정'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(title: 'Home Page'),
                  ),
                );
              },
              child: Text('로그아웃'),
            ),        ],
        ),
      ),
    );
  }
}
