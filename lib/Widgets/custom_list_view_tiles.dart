import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../models/chat_message.dart';
import '../models/chat_user.dart';
class CustomListViewTitleWithActivity extends StatelessWidget{
  final double height;
  final String title;
  final String subtitle;
  final String imagePath;
  final bool isActive;
  final bool isActivity;
  final Function onTap;
  CustomListViewTitleWithActivity({
    required this.height,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.isActive,
    required this.isActivity,
    required this.onTap,
});
  @override
  Widget build(BuildContext context) {
   return ListTile(
     onTap: ()=>onTap(),
     minVerticalPadding: height*0.20,
     leading: ,
     title: Text(title,style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w500,),),
   );
  }
}