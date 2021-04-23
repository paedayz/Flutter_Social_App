import 'package:flutter/material.dart';

class ChatRobby extends StatefulWidget {
  @override
  _ChatRobbyState createState() => _ChatRobbyState();
}

class _ChatRobbyState extends State<ChatRobby> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Robby'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('welcome to chat robby screen'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).pop(),
        label: Text('Click'),
      ),
    );
  }
}
