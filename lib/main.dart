import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// Screen
import './views/home.dart';
import './views/postScreen.dart';
import './views/signInScreen.dart';
import './views/addPostScree.dart';
import './views/chatRobby.dart';

// Function
import './services/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue[600],
      ),
      home: FutureBuilder(
        future: AuthMethods().getCurrentUser(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return Home();
          } else {
            return SignIn();
          }
        },
      ),
      routes: {
        '/postscreen': (BuildContext context) => PostScreen(),
        '/addPostScreen': (BuildContext context) => AddPostScreen(),
        '/homescreen': (BuildContext context) => Home(),
        '/chatRobby': (BuildContext context) => ChatRobby(),
      },
    );
  }
}
