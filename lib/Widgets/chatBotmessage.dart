import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import '../Widgets/rounded_image.dart';
import '../providers/authentication_provider.dart';
class ChatMessage extends StatelessWidget {
  final double size;
  const ChatMessage({
    Key ? key,
    required this.size,
    required this.text,
    required this.sender
  }): super(key: key);
  final String text;
  final String sender;
  @override
  Widget build(BuildContext context) {
    AuthenticationProvider _auth=Provider.of<AuthenticationProvider>(context);
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      sender == 'user' ? RoundedImageNetwork(key: GlobalKey(), imagePath: _auth.user.imageURL, size: size)
          : RoundedImageNetwork(key: GlobalKey(), imagePath: "https://th.bing.com/th/id/OIP.kwJH4fC-iCHuCF2Ar4_vfgHaHa?pid=ImgDet&rs=1", size: size),
      Expanded(child: text.trim().text.bodyText1(context).make().px8())
    ], ).py8();
  }
}