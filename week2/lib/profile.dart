import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  @override
  ProfileStage createState() => ProfileStage();
}

class ProfileStage extends State<Profile> {
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
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 16),
          GestureDetector(
            onTap: _showOptionsDialog,
            child: CircleAvatar(
              radius: 64,
              backgroundImage: _selectedImage != null
                  ? FileImage(_selectedImage!)
                  : AssetImage('assets/profile_image.jpg') as ImageProvider<Object>?,
            ),
          ),
          SizedBox(height: 16),
          Text(
            '사용자 이름',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              children: List.generate(9, (index) {
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/post_$index.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
