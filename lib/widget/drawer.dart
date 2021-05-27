import 'package:chat_app/modal/user_info.dart';
import 'package:chat_app/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  VoidCallback backBTN;

  MyDrawer({@required this.backBTN});

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(
                right: MediaQuery.of(context).size.width / 1.9, top: 50),
            child: ListView(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blueGrey,
                  radius: 50,
                  child: Center(
                    child: Text(
                      "${UserInfo.username[0]}",
                      style:
                          TextStyle(color: CupertinoColors.white, fontSize: 34),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "${UserInfo.username}",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.update),
                  title: Text(
                    "Update",
                    style: TextStyle(fontSize: 20),
                  ),
                  horizontalTitleGap: 20,
                ),
                ListTile(
                  leading: Icon(Icons.star),
                  title: Text(
                    "Rate",
                    style: TextStyle(fontSize: 20),
                  ),
                  horizontalTitleGap: 20,
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text(
                    "Logout",
                    style: TextStyle(fontSize: 20),
                  ),
                  minVerticalPadding: 10,
                  onTap: () async {
                    if (await auth.signOut()) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Sign out successfully ... ")));
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          "/login_screen", (route) => false);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Sign out failed ... ")));
                    }
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                widget.backBTN();
              },
              icon: Icon(Icons.arrow_back),
              iconSize: 24,
            ),
          ),
        ],
      ),
    );
  }
}
