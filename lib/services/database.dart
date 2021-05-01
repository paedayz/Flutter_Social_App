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
    return FirebaseFirestore.instance.collection('posts').add(postInfo).then(
        (value) => FirebaseFirestore.instance
            .collection('posts')
            .doc(value.id)
            .collection('likes')
            .add({"username": ""}));
  }

  Future editPost(Map postInfo, String postId) async {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .update(postInfo);
  }

  Future<Stream<QuerySnapshot>> getAllPost() async {
    return FirebaseFirestore.instance
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<DocumentSnapshot> getPostDetail(String postId) async {
    return FirebaseFirestore.instance.collection('posts').doc(postId).get();
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

  Future deletePost(String postId) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .get()
        .then((value) {
      print(value.docs.map((e) {
        FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .collection('likes')
            .doc(e.id)
            .delete();
      }));
    });
    return FirebaseFirestore.instance.collection('posts').doc(postId).delete();
  }

  // Future<QuerySnapshot> getUserInfo(String username) async {
  //   return await FirebaseFirestore.instance
  //       .collection('users')
  //       .where('username', isEqualTo: username)
  //       .get();
  // }

  Future<Stream<QuerySnapshot>> getUserByUsername(String username) async {
    return FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .snapshots();
  }

  Future addMessage(
      String chatRoomId, String messageId, Map messageInfoMap) async {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('chats')
        .doc(messageId)
        .set(messageInfoMap);
  }

  updateLastMessageSend(String chatRoomId, Map lastMessageInfoMap) {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomId)
        .update(lastMessageInfoMap);
  }

  Future createChatRoom(String chatRoomId, Map chatRoomInfoMap) async {
    final snapShot = await FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomId)
        .get();

    if (snapShot.exists) {
      // chatroom already exists
      return true;
    } else {
      // chatroom do not exists
      return FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }

  Future<Stream<QuerySnapshot>> getChatRoomMessages(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('chats')
        .orderBy('ts', descending: true)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getChatRooms() async {
    String myUsername = await SharedPreferenceHelper().getUserName();
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .where('users', arrayContains: myUsername)
        .snapshots();
  }

  Future<QuerySnapshot> getUserInfo(String username) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();
  }
}
