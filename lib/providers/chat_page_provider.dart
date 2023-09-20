import 'dart:async';
//packages
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
//services
import '../services/database_Service.dart';
import '../services/navigation_services.dart';
import '../services/cloud_storage_service.dart';
import '../services/media_service.dart';

//providers
import '../providers/authentication_provider.dart';
//Models
import '../models/chat_message.dart';

class ChatPageProvider extends ChangeNotifier{
  late DatabaseServices _db;
  late NavigationService _navigation;
  late MediaService _media;
  late CloudStorageService _storage;
  AuthenticationProvider _auth;
  ScrollController _messageListViewController;
  String _chatId;
  late StreamSubscription _messagesStream,_keyboardVisiblityStream;
  late KeyboardVisibilityController _keyboardVisibilityController;
  List<ChatMessage>? messages;
  String? _message;
  ChatPageProvider(this._chatId,this._auth,this._messageListViewController){
    _db=GetIt.instance.get<DatabaseServices>();
    _storage=GetIt.instance.get<CloudStorageService>();
    _media=GetIt.instance.get<MediaService>();
    _navigation=GetIt.instance.get<NavigationService>();
    _keyboardVisibilityController=KeyboardVisibilityController();
    listenToMessages();
    listenToKeyboardChanges();
  }
  String get message
  {
    return _message!;
  }
 void set message(String _value)
 {
  _message=_value;
 }
  @override
  void dispose() {
    _messagesStream.cancel();
    super.dispose();
  }
  void listenToMessages()
  {
        try{
         _messagesStream=_db.streamMessagesFromChat(_chatId).listen((_snapshot) {
           List <ChatMessage> _messages = _snapshot.docs.map((_m) {
             Map<String,dynamic> _messageData = _m.data() as Map<String,dynamic>;
             return ChatMessage.fromJSON(_messageData);
           },).toList();
           messages=_messages;
           notifyListeners();
           WidgetsBinding.instance!.addPostFrameCallback((_) {
             if(_messageListViewController.hasClients)
               {
                 _messageListViewController.jumpTo(_messageListViewController.position.maxScrollExtent);
               }
           });

         });
        }catch(e)
    {
      print("Error getting messages");
      print(e);
    }
  }
  void listenToKeyboardChanges()
  {
    _keyboardVisiblityStream=_keyboardVisibilityController.onChange.listen((event) {
      _db.updateChatData(_chatId, {"is_activity":event});
    });

  }
  void deleteChat()
  {
    goBack();
    _db.deleteChat(_chatId);
  }
  void sendTextMessage()
  {
    if(_message != null)
      {
        ChatMessage _messageToSend=ChatMessage(
            content: _message!,
            senderID: _auth.user.uid,
            type: MessageType.TEXT,
            sentTime: DateTime.now());
        _db.addMessageToChat(_chatId, _messageToSend);
      }
  }
  void sendImageMessage() async
  {
   try{
     PlatformFile? _file=await _media.pickImageFromLibrary();
     if(_file != null)
       {
         String? _downloadURL=await _storage.saveChatImageToStorage(_chatId, _auth.user.uid, _file!);
           ChatMessage _messageToSend=ChatMessage(
               content: _downloadURL!,
               senderID: _auth.user.uid,
               type: MessageType.IMAGE,
               sentTime: DateTime.now());
           _db.addMessageToChat(_chatId, _messageToSend);
       }
   }catch(e)
    {
      print("Error sending image message");
    }
  }
  void goBack()
  {
    _navigation.goBack();
  }

}