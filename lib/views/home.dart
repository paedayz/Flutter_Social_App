import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/auth.dart';
import './signInScreen.dart';
import '../services/database.dart';
import '../helperFunctions/sharedpref_helper.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream postStream;
  String ownUsername;

  addPost() {
    print('add post');
  }

  getAllPost() async {
    postStream = await DatabaseMethods().getAllPost();
    ownUsername = await SharedPreferenceHelper().getUserName();
    setState(() {});
  }

  Widget allPost() {
    return StreamBuilder(
        stream: postStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    // print(ds['likexs']);
                    if (ds.exists) {
                      return postTile(ds['body'], ds['username'],
                          ds['imageUrl'], ds['likeCount'], ds.id, ownUsername);
                    } else {
                      return Text('test');
                    }
                  },
                )
              : Text('no post now');
        });
  }

  Widget postTile(String body, String postBy, String imageUrl, int likeCount,
      String id, String ownUsername) {
    var _isLike = false;

    likePost() {
      print('like post');
      _isLike = true;
      // var likeInfo = {};
      DatabaseMethods().likePost(id, likeCount);
      setState(() {});
    }

    unLikePost(String likeId) {
      print('unlike post');
      // _isLike = true;
      // var likeInfo = {};
      DatabaseMethods().unlikePost(id, likeId, likeCount);
      // setState(() {});
    }

    return Row(
      children: [
        SizedBox(width: MediaQuery.of(context).size.width / 11.5),
        Container(
          width: MediaQuery.of(context).size.width / 1.2,
          height: 190,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.network(
                      imageUrl,
                      height: 40,
                      width: 40,
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    '$postBy',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Text('$body'),
              SizedBox(height: 30),
              Container(
                margin: const EdgeInsets.only(right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('posts')
                            .doc(id)
                            .collection('likes')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var ds = snapshot.data.docs;
                            var flag = 0;
                            var likeId = "";
                            for (var i = 0; i < ds.length; i++) {
                              if (ds[i]['username'] == ownUsername) {
                                flag = 1;
                                likeId = ds[i].id;
                              }
                            }

                            if (flag == 0) {
                              return GestureDetector(
                                onTap: () => likePost(),
                                child: Icon(Icons.favorite_outline),
                              );
                            } else {
                              return GestureDetector(
                                  onTap: () => unLikePost(likeId),
                                  child: Icon(Icons.favorite));
                            }
                          } else {
                            return GestureDetector(
                              onTap: () => likePost(),
                              child: Icon(Icons.favorite_outline),
                            );
                          }
                        }),
                    SizedBox(width: 10),
                    Text('$likeCount'),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    getAllPost();
    super.initState();
  }

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
      body: Container(
        color: Colors.blue[50],
        child: Center(
          child: Stack(
            children: [allPost()],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed('/addPostScreen'),
        child: Icon(Icons.add),
        tooltip: 'Create Post',
      ),
    );
  }
}
