import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_app/services/database.dart';
import 'package:social_app/views/chatscreen.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../video_call/call.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatRoomListTile extends StatefulWidget {
  final String lastMessage, chatRoomId, myUsername, lastCallTo;
  final Timestamp lastMessageSendTs;
  final bool isCalling;
  ChatRoomListTile(this.lastMessage, this.chatRoomId, this.myUsername,
      this.lastMessageSendTs, this.isCalling, this.lastCallTo);

  @override
  _ChatRoomListTileState createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  String profilePicUrl, name, username;

  getThisUserInfo() async {
    username =
        widget.chatRoomId.replaceAll(widget.myUsername, '').replaceAll('_', '');
    QuerySnapshot querySnapshot = await DatabaseMethods().getUserInfo(username);
    name = querySnapshot.docs[0]['name'];
    profilePicUrl = querySnapshot.docs[0]['imgUrl'];
    setState(() {});
  }

  Future<void> onJoin() async {
    DatabaseMethods().answerCalling(widget.chatRoomId);

    // await for camera and mic permissions before pushing video page
    await _handleCameraAndMic(Permission.camera);
    await _handleCameraAndMic(Permission.microphone);
    // push video page with given channel name
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallPage(
          channelName: widget.chatRoomId,
          role: ClientRole.Broadcaster,
        ),
      ),
    );
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }

  @override
  void initState() {
    getThisUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return profilePicUrl != null
        ? Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(username, name),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.network(
                            profilePicUrl,
                            height: 30,
                            width: 30,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(username),
                                Text(
                                  widget.lastMessage,
                                  style: TextStyle(
                                    color: Colors.black45,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      child: widget.isCalling == true &&
                              widget.lastCallTo == widget.myUsername
                          ? GestureDetector(
                              onTap: () {
                                onJoin();
                              },
                              child: Icon(Icons.phone_callback_outlined))
                          : Text(
                              '${timeago.format(DateTime.fromMillisecondsSinceEpoch(widget.lastMessageSendTs.millisecondsSinceEpoch))}',
                              style: TextStyle(
                                color: Colors.black38,
                              ),
                              textAlign: TextAlign.left,
                            ),
                    ),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
            ],
          )
        : Container();
  }
}
