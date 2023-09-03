import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/database_Service.dart';
import '../providers/authentication_provider.dart';
import '../models/chat_user.dart';
import '../models/chat_message.dart';
import '../models/chat.dart';
class ChatsPageProvider extends ChangeNotifier{
  AuthenticationProvider _auth;
  late DatabaseServices _db;
  List<Chat>? chats;
  late StreamSubscription _chatsStream;
  ChatsPageProvider(this._auth){
    _db=GetIt.instance.get<DatabaseServices>();
    getChats();
  }
  @override
  void dispose() {
    _chatsStream.cancel();
    super.dispose();
  }
  void getChats() async
  {
         try{
           _chatsStream=_db.getChatsForUser(_auth.user.uid).listen((_snapshot) async{
             chats = await Future.wait(_snapshot.docs.map((_d) async {
               Map<String, dynamic> _chatData = _d.data() as Map<String,
                   dynamic>;
               //getusersinchat
               List<ChatUser> _members=[];
               for(var _uid in _chatData["members"])
                 {
                   DocumentSnapshot _userSnapshot=await _db.getUser(_uid);
                   Map<String,dynamic> _userData=_userSnapshot.data() as Map<String,dynamic>;
                   _userData["_uid"]=_userSnapshot.id;
                   _members.add(ChatUser.fromJSON(_userData),);
                 }
               //get last message in chat
               List<ChatMessage> _messages=[];
               QuerySnapshot _chatMesaage=await _db.getLastMessageFromChat(_d.id);
               if(_chatMesaage.docs.isNotEmpty)
                 {
                   Map<String,dynamic> _messageData=_chatMesaage.docs.first.data()! as Map<String,dynamic>;
                   ChatMessage _message=ChatMessage.fromJSON(_messageData);
                   _messages.add(_message);
                 }

               return Chat(
                 uid: _d.id,
                 currentUserUid: _auth.user.uid,
                 members: _members,
                 messages: _messages,
                 activity: _chatData["is_activity"],
                 group: _chatData["is_group"],
               );
             },
             ).toList(),
             );
             notifyListeners();
           });
         }
         catch(e)
    {
      print("Error getting chats");
      print(e);
    }
  }

}