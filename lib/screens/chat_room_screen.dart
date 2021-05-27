import 'dart:math';
import 'package:chat_app/helper/conversation_helper.dart';
import 'package:chat_app/widget/drawer.dart';
import '../services/database_method.dart';
import 'package:chat_app/modal/user_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Stream<QuerySnapshot<Map<String, dynamic>>> chatRoomStream;
  double value = 0;
  bool isFirst = false;

  @override
  void initState() {
    myDatabase.getChatRoom(UserInfo.uid).then((value) {
      setState(() {
        chatRoomStream = value;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    myDatabase.getChatRoom(UserInfo.uid).then((value) {
      setState(() {
        chatRoomStream = value;
      });
    });
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            MyDrawer(backBTN: (){
              setState(() {
                value == 0 ? value = 1 : value = 0;
              });
            },),
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: value),
              duration: Duration(milliseconds: 500),
              child: Scaffold(
                appBar: AppBar(
                  leading: InkWell(
                    onTap: () {
                      setState(() {
                        value == 0 ? value = 1 : value = 0;
                      });
                    },
                    child: Icon(Icons.menu),
                  ),
                  title: Text("Flutter Chat"),
                ),
                body: chatRoomStream == null
                    ? Container()
                    : StreamBuilder<QuerySnapshot>(
                        stream: chatRoomStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data != null) {
                              List<QueryDocumentSnapshot> data =
                                  snapshot.data.docs;
                              if (data.isNotEmpty) {
                                return ListView.builder(
                                  itemCount: data.length,
                                  itemBuilder: (context, i) {
                                    List usernameList = data[i].get("username");
                                    String username = usernameList.firstWhere(
                                        (element) =>
                                            element != UserInfo.username);
                                    List emailList = data[i].get("email");
                                    String email = emailList.firstWhere(
                                        (element) => element != UserInfo.email);
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.blueGrey,
                                              Colors.transparent
                                            ],
                                            stops: [0.4, 1.0],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                        ),
                                        child: ListTile(
                                          onTap: () {
                                            String uid = data[i]
                                                .get("chatRoomId")
                                                .toString()
                                                .replaceAll(UserInfo.uid, "")
                                                .replaceAll("_", "");
                                            ConversationHelper
                                                    .createChatScreenAndStartConversation(
                                                        uid: uid,
                                                        username: username,
                                                        userEmail: email)
                                                .then((value) => value
                                                    ? Navigator.of(context)
                                                        .pushNamed(
                                                            "/conversation_screen",arguments: username)
                                                    : ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            content: Text(
                                                                "Can not send message to yourself ..."))));
                                          },
                                          leading: CircleAvatar(
                                            radius: 30,
                                            child: Text(
                                              "${username.toString().replaceAll(UserInfo.uid, "").replaceAll("_", "").substring(0, 1).toUpperCase()}",
                                              style: TextStyle(
                                                fontSize: 24,
                                                color: CupertinoColors.white,
                                              ),
                                            ),
                                            backgroundColor:
                                                Colors.deepPurpleAccent[100],
                                          ),
                                          title: Text(
                                            "${username.toString().replaceAll("_", "").replaceAll(UserInfo.uid, "")}",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          subtitle: Text(
                                            "${email.toString().replaceAll("_", "").replaceAll(UserInfo.uid, "")}",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          trailing: CircleAvatar(
                                            child: Icon(
                                              Icons.arrow_forward_ios,
                                              color: Colors.white,
                                            ),
                                            backgroundColor:
                                                CupertinoColors.systemPurple,
                                            radius: 18,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                              return Center(
                                child: Text("No data found"),
                              );
                            }
                          }
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                floatingActionButton: FloatingActionButton(
                  heroTag: "search",
                  backgroundColor: Colors.purpleAccent[100],
                  child: Icon(Icons.search),
                  onPressed: () {
                    Navigator.of(context).pushNamed("/search_screen");
                  },
                ),
              ),
              builder: (context, val, child) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..setEntry(0, 3, 200 * val)
                    ..rotateY((pi / 6) * val),
                  child: child,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
