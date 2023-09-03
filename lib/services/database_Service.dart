import 'package:cloud_firestore/cloud_firestore.dart';
const String USER_COLLECTION ="Users";
const String CHAT_COLLECTION ="Chats";
const String MESSAGE_COLLECTION ="messages";
class DatabaseServices{
  final FirebaseFirestore _db=FirebaseFirestore.instance;
  DatabaseService() {}
  Future<void> createUser(String _uid,String _email,String _name,String _imageURL) async
  {
    try{
     await _db.collection(USER_COLLECTION).doc(_uid).set(
       {
         "email":_email,
         "image":_imageURL,
         "last_active":DateTime.now().toUtc(),
         "name":_name,
       }
     );
    }catch(e)
    {
      print(e);
    }
  }
  Future<DocumentSnapshot> getUser(String _uid)
  {
    return _db.collection(USER_COLLECTION).doc(_uid).get();
  }
  Stream<QuerySnapshot> getChatsForUser(String _uid){
    return _db
        .collection(CHAT_COLLECTION)
        .where('members',arrayContains: _uid)
        .snapshots();
  }
  Future<QuerySnapshot> getLastMessageFromChat(String _chatId)
  {
    return _db
        .collection(CHAT_COLLECTION)
        .doc(_chatId)
        .collection(MESSAGE_COLLECTION)
        .orderBy("sent_time",descending: true)
        .limit(1)
        .get();
  }
  Future<void> updateUserLastSeenTime(String _uid)async{
    try{
         await _db.collection(USER_COLLECTION).doc(_uid).update({
           "last_active":DateTime.now().toUtc(),
         },);
    }
    catch(e)
    {
      print(e);
    }
  }
}