import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'app.dart';

void main() {
  KakaoSdk.init(nativeAppKey: '2b2769f5a2d2fc04360cee281d2c2ef2');
  runApp(const MyApp());
}