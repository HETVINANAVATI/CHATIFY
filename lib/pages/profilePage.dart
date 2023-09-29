
import 'package:provider/provider.dart';
import '../Widgets/rounded_button.dart';
import '../Widgets/rounded_image.dart';
import '../providers/authentication_provider.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
class Profilepage extends StatefulWidget{
  Profilepage();
 @override
  State<StatefulWidget> createState() {
   return _profilePageState();
  }
}
class _profilePageState extends State<Profilepage>
{
  late AuthenticationProvider _auth;
  late double _deviceWidth;
  late double _deviceHeight;
  @override
  Widget build(BuildContext context) {
    _deviceHeight=MediaQuery.of(context).size.height;
    _deviceWidth=MediaQuery.of(context).size.width;
    _auth=Provider.of<AuthenticationProvider>(context);
   return Scaffold(
     appBar: AppBar(centerTitle: true, title: Text("Profile"),iconTheme: IconThemeData(color: Color.fromRGBO(0, 82, 218, 1.0)),
       backgroundColor: Color.fromRGBO(36, 35, 49, 1.0),
     ),
     body: Container(
        padding: EdgeInsets.symmetric(horizontal: _deviceWidth*0.03,vertical: _deviceHeight*0.02),
    height: _deviceHeight*0.98,
    width: _deviceWidth*0.97,
    child: Column(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(
        height: _deviceHeight*0.05,
      ),
      _profileImageField(),
      SizedBox(
        height: _deviceHeight*0.05,
      ),
      Text("Name: " + _auth.user.name,style: TextStyle(fontWeight: FontWeight.w900,fontSize: 25),),
      SizedBox(
        height: _deviceHeight*0.05,
      ),
      Text("Email: " + _auth.user.email,style: TextStyle(fontWeight: FontWeight.w900,fontSize: 20),),
      SizedBox(
        height: _deviceHeight*0.05,
      ),
      Text("Last Active: " + timeago.format(_auth.user.lastActive),style: TextStyle(fontWeight: FontWeight.w900,fontSize: 20),),
      SizedBox(
        height: _deviceHeight*0.05,
      ),
      _logOutButton(),
    ],
    )
     ),
   );
  }
  Widget _profileImageField()
  {
    return RoundedImageNetwork(key: GlobalKey(),imagePath: _auth.user.imageURL,size:_deviceHeight*0.15,);
  }
  Widget _logOutButton()
  {
    return RoundedButton(name: "Log Out", height: _deviceHeight*0.078, width: _deviceWidth*0.68, onPressed: (){
      _auth.logout();
    });
  }
}

