import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth.dart';
import './signInScreen.dart';
import '../services/database.dart';
import '../helperFunctions/sharedpref_helper.dart';
import './postDetailScreen.dart';

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
                    if (ownUsername == ds['username']) {
                      return Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          child: Icon(Icons.delete, color: Colors.white),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20.0),
                        ),
                        onDismissed: (direction) {
                          print(direction);
                          DatabaseMethods().deletePost(ds.id);
                        },
                        child: postTile(
                            ds['body'],
                            ds['username'],
                            ds['imageUrl'],
                            ds['likeCount'],
                            ds.id,
                            ownUsername),
                      );
                    } else {
                      return postTile(ds['body'], ds['username'],
                          ds['imageUrl'], ds['likeCount'], ds.id, ownUsername);
                    }
                  },
                )
              : Text('no post now');
        });
  }

  Widget postTile(String body, String postBy, String imageUrl, int likeCount,
      String id, String ownUsername) {
    likePost() {
      DatabaseMethods().likePost(id, likeCount);
    }

    unLikePost(String likeId) {
      DatabaseMethods().unlikePost(id, likeId, likeCount);
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return PostDetail(id: id);
          }),
        );
      },
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 4,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Image.network(
                    imageUrl,
                    height: 40,
                    width: 40,
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${postBy.toUpperCase()}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            '$body',
                            style: GoogleFonts.notoSans(),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          right: 20,
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.7,
                            ),
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
            ),
          ),
        ],
      ),
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
        leading: SizedBox(
          width: 2,
        ),
        title: Text('Homepage'),
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed('/chatRobby');
            },
            child: Container(
              child: Icon(Icons.message),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
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
            children: [
              allPost(),
            ],
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
