import 'package:flutter/material.dart';

class EditPost extends StatefulWidget {
  var id;

  EditPost({Key key, @required this.id}) : super(key: key);
  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Post'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('welcome to edit post screen'),
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
