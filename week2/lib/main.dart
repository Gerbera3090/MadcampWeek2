import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'app.dart';
import 'user_provider.dart';

const String addressUrl = "https://a800-192-249-19-234.ngrok-free.app/mainapp";

void main() {


  KakaoSdk.init(nativeAppKey: '2b2769f5a2d2fc04360cee281d2c2ef2');
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: const MyApp(),
    ),
  );
}
