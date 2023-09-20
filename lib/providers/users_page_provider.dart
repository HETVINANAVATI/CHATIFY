//package
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
//services
import '../services/database_Service.dart';
import '../services/navigation_services.dart';
//Providers
import '../providers/authentication_provider.dart';
//models
import '../models/chat_user.dart';
import '../models/chat.dart';
//pages
import '../pages/chat_page.dart';
class UsersPageProvider extends ChangeNotifier{
  AuthenticationProvider _auth;
  late DatabaseServices _db;
  late NavigationService _navigation;
  List<ChatUser>? users;
  late List<ChatUser> _selectedUser;
  List<ChatUser> get selectedUser
  {
    return _selectedUser;
  }
  UsersPageProvider(this._auth){
  _selectedUser=[];
  _db=GetIt.instance.get<DatabaseServices>();
  _navigation=GetIt.instance.get<NavigationService>();
  getUsers();
}
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  void getUsers({String? name})
  {
    _selectedUser=[];
    try{
      _db.getUsers(name:name).then((_snapshot) {
          users=_snapshot.docs.map((_doc) {
            Map<String,dynamic> _data=_doc.data() as Map<String,dynamic>;
            _data["uid"]=_doc.id;
            return ChatUser.fromJSON(_data);
          }).toList();
          notifyListeners();
      });
    }
    catch(e)
    {
         print("Error getting users");
         print(e);
    }
  }
  void updateSelectedUsers(ChatUser _user)
  {
    if(_selectedUser.contains(_user))
      {
        _selectedUser.remove(_user);
      }
    else
      {
        _selectedUser.add(_user);
      }
    notifyListeners();
  }
  void createChat()async{
    try{
      //create chat
        List<String> _membersId=_selectedUser.map((_user) => _user.uid).toList();
        _membersId.add(_auth.user.uid);
        bool _isGroup=_selectedUser.length>1;
        DocumentReference? _doc=await _db.createChat({
          "is_group":_isGroup,
          "is_activity":false,
          "members":_membersId,
        });
        //navigate to chat page
      List<ChatUser> _members=[];
      for(var _uid in _membersId)
        {
          DocumentSnapshot _userSnapshot=await _db.getUser(_uid);
          Map<String,dynamic> _userData=_userSnapshot.data() as Map<String,dynamic>;
          _userData["uid"]=_userSnapshot.id;
          _members.add(ChatUser.fromJSON(_userData));
        }
      ChatPage _chatPage=ChatPage(chat: Chat(uid: _doc!.id,currentUserUid: _auth.user.uid,members: _members,messages: [],activity: false,group: _isGroup));
     _selectedUser=[];
     notifyListeners();
      _navigation.navigateToPage(_chatPage);
    }
    catch(e)
    {
      print("Error creating chat.");
      print(e);
    }
  }
}