import 'package:chat_app/helper/conversation_helper.dart';
import '../services/database_method.dart';
import 'package:chat_app/modal/user_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  QuerySnapshot _querySnapshot;
  String username;

  @override
  void initState() {
    UserInfo.saveUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: Duration(milliseconds: 1500),
          child: Scaffold(
            appBar: AppBar(
              title: TextField(
                onChanged: (val) {
                  myDatabase.getUserByUserName(val).then((value) {
                    setState(() {
                      _querySnapshot = value;
                    });
                  });
                  username = val;
                },
                decoration: InputDecoration(
                  hintText: "Search",
                  border: InputBorder.none,
                ),
                style: TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                textAlign: TextAlign.start,
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.search),
                ),
              ],
            ),
            body: _querySnapshot == null
                ? Container()
                : ListView.builder(
              itemCount: _querySnapshot.docs.length,
              itemBuilder: (context, i) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Card(
                    child: ListTile(
                      title: Text(_querySnapshot.docs[i].get("username")),
                      subtitle: Text(_querySnapshot.docs[i].get('email')),
                      tileColor: Colors.black45,
                      trailing: CircleAvatar(
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                        backgroundColor: CupertinoColors.systemPurple,
                        radius: 18,
                      ),
                      onTap: () async {
                        String uid = _querySnapshot.docs[i].get("uid");
                        String username = _querySnapshot.docs[i].get("username");
                        String email = _querySnapshot.docs[i].get("email");
                        ConversationHelper.createChatScreenAndStartConversation(
                            uid: uid,username: username,userEmail: email)
                            .then((value) => value
                            ? Navigator.of(context)
                            .pushNamed("/conversation_screen")
                            : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "Can not send message to yourself ..."))));
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          builder: (context, val, child) {
            return ShaderMask(
              shaderCallback: (rect) {
                return RadialGradient(
                  radius: val * 5,
                  colors: [Colors.white, Colors.white,Colors.transparent,Colors.transparent],
                  stops: [0.1,0.3,0.9, 1.0],
                  center: FractionalOffset(0.95,0.95),
                ).createShader(rect);
              },
              child: child,
            );
          },
        ),
      ),
    );
  }
}
