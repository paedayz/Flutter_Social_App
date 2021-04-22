import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PostDetail extends StatefulWidget {
  var id;

  PostDetail({Key key, @required this.id}) : super(key: key);
  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  test() {
    print(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Detail'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('${widget.id}'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => test(),
        label: Text('Click'),
      ),
    );
  }
}
