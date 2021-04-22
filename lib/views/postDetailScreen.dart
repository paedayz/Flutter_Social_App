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
  var postData;
  var postUsername = "x";

  getPostDetail() async {
    detail =
        await DatabaseMethods().getPostDetail(widget.id) as DocumentSnapshot;
    postData = detail.data();
    postUsername = detail.data()['username'];
    setState(() {});
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
      body: postUsername != ""
          ? Container(
              padding: const EdgeInsets.all(20),
              color: Colors.black12,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.network(
                            postData['imageUrl'],
                            height: 40,
                            width: 40,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '${postData['username']}',
                          style: TextStyle(fontSize: 17),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        postData['body'],
                      ),
                    )
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: postData['username'] == 'pdayz19x'
          ? FloatingActionButton.extended(
              onPressed: () => print('testset'),
              label: Text('Click'),
            )
          : Container(),
    );
  }
}
