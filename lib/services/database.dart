import 'package:cloud_firestore/cloud_firestore.dart';
import '../helperFunctions/sharedpref_helper.dart';

class DatabaseMethods {
  Future addUserInfoToDB(
      String userId, Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .set(userInfoMap);
  }

  Future addPost(Map postInfo) async {
    postInfo["username"] = await SharedPreferenceHelper().getUserName();
    postInfo["imageUrl"] = await SharedPreferenceHelper().getUserProfileUrl();
    return FirebaseFirestore.instance.collection('posts').add(postInfo).then(
        (value) => FirebaseFirestore.instance
            .collection('posts')
            .doc(value.id)
            .collection('likes')
            .add({"username": ""}));
  }

  Future<Stream<QuerySnapshot>> getAllPost() async {
    return FirebaseFirestore.instance
        .collection('posts')
        .orderBy('createdAt')
        .snapshots();
  }

  Future likePost(String postId, int likeCount) async {
    var likeInfo = {
      'username': await SharedPreferenceHelper().getUserName(),
      'postId': postId
    };
    Map<String, dynamic> updateLikeCount = {'likeCount': likeCount + 1};
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .update(updateLikeCount)
        .then((value) => FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .collection('likes')
            .add(likeInfo));
  }

  Future unlikePost(String postId, String likeId, int likeCount) async {
    Map<String, dynamic> updateLikeCount = {'likeCount': likeCount - 1};
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .update(updateLikeCount)
        .then((value) => FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .collection('likes')
            .doc(likeId)
            .delete());
  }
}
