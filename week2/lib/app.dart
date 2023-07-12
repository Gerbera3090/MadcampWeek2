// app.dart
import 'package:flutter/material.dart';
import 'home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Q.Feed',
      theme: ThemeData(
         primarySwatch: MaterialColor(
          0xFFFFa3a3,
          <int, Color>{
            50: Color(0xFFFFE7E7),
            100: Color(0xFFFFC6C6),
            200: Color(0xFFFFA4A4),
            300: Color(0xFFFF8282),
            400: Color.fromARGB(255, 255, 165, 165),
            500: Color.fromARGB(255, 255, 164, 164),
            600: Color.fromARGB(255, 255, 159, 159),
            700: Color.fromARGB(255, 255, 149, 149),
            800: Color.fromARGB(255, 255, 142, 142),
            900: Color.fromARGB(255, 255, 113, 113),
          },
        ),
      ),
      home: const MyHomePage(title: 'Q.Feed', ),
    );
  }
}
