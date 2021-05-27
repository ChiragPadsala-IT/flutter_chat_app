import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethod {
  ///create firebase instance
  FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  ///initialize variable to store exception when it's occur
  FirebaseException exception;

  ///name constructor
  DatabaseMethod._();

  Future<DocumentSnapshot<Map<String,dynamic>>> getUserDetails(String uid)async{
    return await _fireStore.collection("user").doc(uid).get();
  }

  /// get user who name will match
  Future getUserByUserName(String username) {
    return _fireStore
        .collection("user")
        .where("username", isEqualTo: username)
        .get();
  }

  /// get user who email will match
  Future getUserByEmail(String email) {
    return _fireStore.collection("user").where("email", isEqualTo: email).get();
  }

  ///upload user data into fireStore
  Future uploadUserInfo(String username, String email,String uid) async {
    Map<String, dynamic> user = {
      "username": username,
      "email": email,
      "uid" : uid,
    };
    try {
      await _fireStore.collection("user").doc(uid).set(user);
      // DocumentReference res = await _fireStore.collection("user").add(user);
      return true;
    } on FirebaseException catch (e) {
      exception = e;
      print(e.message);
      return false;
    }
  }

  ///create chatRoom
  Future createChatRoom(String chatRoomId, Map chatRoomMap) async {
    try {
      await _fireStore.collection("chatRoom").doc(chatRoomId).set(chatRoomMap);
    } on FirebaseException catch (e) {
      exception = e;
      print(e.message);
    }
  }

  ///add chatConversation
  Future addConversationMessage(String chatRoomId, Map messageMap) async {
    await _fireStore
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e);
    });
  }

  ///get old chat Conversation
  Future getConversationMessage(String chatRoomId) async {
    return _fireStore
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time",descending: true)
        .snapshots();
  }

  ///get chatRoom
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getChatRoom(
      String uid) async {
    return _fireStore
        .collection("chatRoom")
        .where("users", arrayContains: uid)
        .snapshots();
  }
}

/// create instance
DatabaseMethod myDatabase = DatabaseMethod._();
