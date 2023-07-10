import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _nickName = '';
  String _uid = '';
  String _password = '';
  String _name = '';
  String _univ = '';
  String _region = '';
  String _phoneNumber = '';
  bool _liked = false;

  String get nickName => _nickName;
  String get uid => _uid;
  String get password => _password;
  String get name => _name;
  String get univ => _univ;
  String get region => _region;
  String get phoneNumber => _phoneNumber;
  bool get liked => _liked;

  void setNickName(String nickName) {
    _nickName = nickName;
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
}
