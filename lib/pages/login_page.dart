import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import '../Widgets/custom_input_fields.dart';
import '../Widgets/rounded_button.dart';
import '../providers/authentication_provider.dart';
import '../services/navigation_services.dart';
class LoginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }

}
class _LoginPageState extends State<LoginPage>
{
  late double _deviceHeight,_deviceWidth;
  late AuthenticationProvider _auth;
  late NavigationService _navigation;
  final _loginFormKey = GlobalKey<FormState>();
  String? _email,_password;
       Widget build(BuildContext context)
       {
         _deviceHeight=MediaQuery.of(context).size.height;
         _deviceWidth=MediaQuery.of(context).size.width;
         _auth=Provider.of<AuthenticationProvider>(context);
         _navigation=GetIt.instance.get<NavigationService>();
          return _buildUI();
       }
       Widget _buildUI()
       {
         return Scaffold(
             resizeToAvoidBottomInset: false,
           body: Container(padding: EdgeInsets.symmetric(horizontal: _deviceWidth*0.03,vertical: _deviceHeight*0.02),
           height: _deviceHeight*0.98,
           width: _deviceWidth*0.97,
           child: Column(
             mainAxisSize: MainAxisSize.max,
             mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [
               SizedBox(
                 height: _deviceHeight*0.05,
               ),
               _pageTitle(),
               SizedBox(
                 height: _deviceHeight*0.04,
               ),
               _loginForm(),
               SizedBox(
                 height: _deviceHeight*0.05,
               ),
               _loginButton(),
               SizedBox(
                 height: _deviceHeight*0.05,
               ),
               _registerAccountLink(),
               SizedBox(
                 height: _deviceHeight*0.02,
               ),
             ],
           ),),

         );
       }
       Widget _pageTitle()
       {
         return Container(
           height: _deviceHeight*0.10,
           child: Text("Chatify",style: TextStyle(color: Colors.white,fontSize: 40,fontWeight: FontWeight.w600),),
         );
       }
       Widget _loginForm()
       {
         return Container(
           height: _deviceHeight*0.24,
           child: Form(key:_loginFormKey,child: Column(
             mainAxisSize: MainAxisSize.max,
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [
             CustomTextFormField(onSaved: (_value){
               setState(() {
                 _email=_value;
               });
             } , regEx:  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                 hintText: "Email", obscuretext: false),
               CustomTextFormField(onSaved: (_value){
                 setState(() {
                   _password=_value;
                 });
               } , regEx: r".{8,}",
                   hintText: "Password", obscuretext: true),
             ],
           ),),
         );
       }
       Widget _loginButton()
       {
          return RoundedButton(
            name: "Login",
            height: _deviceHeight*0.078,
            width: _deviceWidth*0.65,
            onPressed: ()
            {
             if(_loginFormKey.currentState!.validate())
               {
                     _loginFormKey.currentState!.save();
                     _auth.loginUsingEmailAndPasswords(_email!, _password!);
               }
            },
          );
       }
       Widget _registerAccountLink()
       {
         return GestureDetector(
           onTap: ()=>_navigation.navigateToRoute('/register'),
           child:  Container(child: Text('Don\'t have an account?',style: TextStyle(
           color: Colors.blueAccent,
         ),),),
             );
       }
}