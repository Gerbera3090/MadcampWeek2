import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';

class UserProvider with ChangeNotifier {
  String _nickName = '';
  String _uid = '';
  String _password = '';
  String _name = '';
  String _univ = '';
  String _region = '';
  String _phoneNumber = '';
  String _instaId = '';
  String _kakaoId = '';
  String _kakaoEmail = '';
  String _googleEmail = '';
  bool _liked = false;
  Uint8List? photo; // 이미지 데이터를 저장할 필드

  String get nickName => _nickName;
  String get uid => _uid;
  String get password => _password;
  String get name => _name;
  String get univ => _univ;
  String get region => _region;
  String get phoneNumber => _phoneNumber;
  String get instaId => _instaId;
  String get kakaoId => _kakaoId;
  String get kakaoEmail => _kakaoEmail;
  String get googleEmail => _googleEmail;
  bool get liked => _liked;

  void setNickName(String nickName) {
    _nickName = nickName;
    notifyListeners();
  }

  void setInstaId(String instaId) {
    _instaId = instaId;
    notifyListeners();
  }
  void setKakaoId(String kakaoId) {
    _kakaoId = kakaoId;
    notifyListeners();
  }
  void setKakaoEmail(String kakaoEmail) {
    _kakaoEmail = kakaoEmail;
    notifyListeners();
  }
  void setGoogleEmail(String googleEmail) {
    _googleEmail = googleEmail;
    notifyListeners();
  }

  void setUid(String uid) {
    _uid = uid;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  void setUniv(String univ) {
    _univ = univ;
    notifyListeners();
  }

  void setRegion(String region) {
    _region = region;
    notifyListeners();
  }

  void setPhoneNumber(String phoneNumber) {
    _phoneNumber = phoneNumber;
    notifyListeners();
  }

  void toggleLiked() {
    _liked = !_liked;
    notifyListeners();
  }
  
  void setPhoto(String base64String) {
    final decodedBytes = base64Decode(base64String);
    photo = Uint8List.fromList(decodedBytes);
    notifyListeners();
  }
}
