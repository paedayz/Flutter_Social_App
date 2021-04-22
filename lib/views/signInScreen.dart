import "package:flutter/material.dart";

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign in'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('welcome to sign in screen'),
          ],
        ),
      ),
    );
  }
}
