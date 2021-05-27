import '../services/database_method.dart';
import 'package:chat_app/modal/user_info.dart';
import 'package:chat_app/services/auth.dart';

class ConversationHelper{

  static _getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  static Future<bool> createChatScreenAndStartConversation({String uid,String username,String userEmail})async{

    if(uid != UserInfo.uid){
      String chatRoomId = _getChatRoomId(uid, UserInfo.uid);

      UserInfo.chatRoomId = chatRoomId;

      List<String> users = [uid,UserInfo.uid];
      List<String> usernameList = [username,UserInfo.username];
      List<String> userEmailList = [userEmail,UserInfo.email];

      Map<String,dynamic> chatRoomMap = {
        "users" : users,
        "username" : usernameList,
        "email" : userEmailList,
        "chatRoomId" : chatRoomId,
      };
      await myDatabase.createChatRoom(chatRoomId, chatRoomMap);
      return true;
    }else{
      return false;
    }
  }

}