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
    return FirebaseFirestore.instance.collection('posts').add(postInfo);
  }

  Future<Stream<QuerySnapshot>> getAllPost() async {
    return FirebaseFirestore.instance
        .collection('posts')
        .orderBy('createdAt')
        .snapshots();
  }
}
