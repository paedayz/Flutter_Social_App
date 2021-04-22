import 'package:flutter/material.dart';
import './views/home.dart';
import 'views/chatScreen.dart';
import './views/postScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
      routes: {
        '/chatscreen': (BuildContext context) => ChatScreen(),
        '/postscreen': (BuildContext context) => PostScreen(),
      },
    );
  }
}
