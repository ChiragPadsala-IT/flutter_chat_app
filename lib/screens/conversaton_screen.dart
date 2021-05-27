import 'package:chat_app/widget/message_tile.dart';

import '../services/database_method.dart';
import 'package:chat_app/modal/user_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  String conversationUsername;
  ConversationScreen({@required this.conversationUsername});
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  Stream chatMessageStream;

  TextEditingController _messageController = TextEditingController();

  sendMessage() {
    if (_messageController.text != "") {
      Map<String, dynamic> messageMap = {
        "message": _messageController.text,
        "sendBy": UserInfo.uid,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      myDatabase.addConversationMessage(UserInfo.chatRoomId, messageMap);
      getMessage();
      _messageController.clear();
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content : Text("First of all write message on message box")));
    }
  }

  getMessage() {
    myDatabase.getConversationMessage(UserInfo.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
  }

  @override
  void initState() {
    getMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String friendName = ModalRoute.of(context).settings.arguments;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text("$friendName"),
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: chatMessageStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (chatMessageStream != null) {
                        List<QueryDocumentSnapshot> data = snapshot.data.docs;
                        return ListView.builder(
                          reverse: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (context, i) {
                            return MessageTile(
                              message: data[i].get("message"),
                              isSendByMe: data[i].get("sendBy") ==
                                  UserInfo.uid,
                            );
                          },
                        );
                      }
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
              Container(
                color: Colors.black45,
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                  title: TextField(
                    controller: _messageController,
                    textInputAction: TextInputAction.send,
                    style: TextStyle(
                      letterSpacing: 1,
                      fontSize: 16,
                    ),
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: "Write message",
                      hintStyle: TextStyle(letterSpacing: 2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                  ),
                  trailing: CircleAvatar(
                    radius: 24,
                    child: IconButton(
                      icon: Icon(Icons.send_outlined),
                      onPressed: () {

                        sendMessage();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


