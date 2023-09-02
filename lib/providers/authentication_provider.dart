import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import '../services/database_Service.dart';
import '../services/navigation_services.dart';
import '../models/chat_user.dart';
class AuthenticationProvider extends ChangeNotifier{
  late final FirebaseAuth _auth;
  late final NavigationService _navigationService;
  late final DatabaseServices _databaseServices;
  late ChatUser user;
  AuthenticationProvider()
  {
    _auth=FirebaseAuth.instance;
    _navigationService=GetIt.instance.get<NavigationService>();
    _databaseServices=GetIt.instance.get<DatabaseServices>();
    _auth.signOut();
    _auth.authStateChanges().listen((_user){
      if(_user != null)
        {
            _databaseServices.updateUserLastSeenTime(_user.uid);
            _databaseServices.getUser(_user.uid).then((_snapshot) {
              Map<String,dynamic> _userData=_snapshot.data()! as Map<String,dynamic>;
             user=ChatUser.fromJSON({
               "uid":_user.uid,
               "name":_userData["name"],
               "email":_userData["email"],
               "last_active":_userData["last_active"],
               "image":_userData["image"],
             },);
             _navigationService.removeAndNavigateToRoute("/home");
            });
        }
      else
        {
          _navigationService.removeAndNavigateToRoute("/login");
        }
    });
  }
  Future<void> loginUsingEmailAndPasswords(String _email,String _password) async
  {
    try {
      await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);
    }on FirebaseAuthException{
      print("Error logging user into firebase");
  }catch(e)
    {
      print(e);
    }
  }
  Future<String?> registerUserUsingEmailAndPasswords(String _email,String _password) async{
    try{
        UserCredential _credentials=await _auth.createUserWithEmailAndPassword(email: _email, password: _password);
        return _credentials.user!.uid;
    }on FirebaseAuthException{
      print("Error registering user into firebase");
    }
    catch(e)
    {
       print(e);
    }
  }
  Future <void> logout() async
  {
    try{
       await _auth.signOut();
    }catch(e)
    {
      print(e);
    }
  }
}