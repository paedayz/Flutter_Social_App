import 'package:flutter/material.dart';
import '../services/auth.dart';
import './signInScreen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Homepage'),
        actions: [
          InkWell(
            onTap: () {
              AuthMethods().signOut().then((s) {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => SignIn()));
              });
            },
            child: Container(
              child: Icon(Icons.logout),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ],
      ),
      body: Center(
        child: Text('welcome to homepage'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).pushNamed('/postscreen'),
        label: Text('Click'),
      ),
    );
  }
}
