/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///   세 번째 탭. 닉네임이랑, 자기가 댓글 단 게시물을 받아 옴. 핀 꼽기도 가능. 사진을 누르면 profile_setting.dart로 넘어감   ///
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';

class Tab3Page extends StatefulWidget {
  @override
  _Tab3PageState createState() => _Tab3PageState();
}

class _Tab3PageState extends State<Tab3Page> {
  File? _selectedImage;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);

    setState(() {
      if (pickedImage != null) {
        _selectedImage = File(pickedImage.path);
      }
    });
  }

  Future<void> _pickImageFromGallery() async {
    await _pickImage(ImageSource.gallery);
  }

  Future<void> _pickImageFromCamera() async {
    await _pickImage(ImageSource.camera);
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            GestureDetector(
              onTap: _showOptionsDialog,
              child: CircleAvatar(
                radius: 64,
                backgroundImage: _selectedImage != null
                    ? FileImage(_selectedImage!) as ImageProvider<Object>?
                    : AssetImage('assets/profile_image.jpg')
                        as ImageProvider<Object>?, // 프로필 사진이 없으면 파란색으로 기본 프로필
              ),
            ),
            SizedBox(height: 16),
            Text(
              userProvider.nickName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
