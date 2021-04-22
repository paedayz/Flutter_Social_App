import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/database.dart';

// ignore: must_be_immutable
class PostDetail extends StatefulWidget {
  var id;

  PostDetail({Key key, @required this.id}) : super(key: key);
  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  DocumentSnapshot detail;

  getPostDetail() async {
    detail =
        await DatabaseMethods().getPostDetail(widget.id) as DocumentSnapshot;
    print(detail.data()['username']);
  }

  @override
  void initState() {
    getPostDetail();
    super.initState();
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
            // Text('${detail['usrename']}'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => print('testset'),
        label: Text('Click'),
      ),
    );
  }
}
