//packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//widgets
import '../Widgets/top_bar.dart';
import '../Widgets/custom_list_view_tiles.dart';
import '../Widgets/custom_input_fields.dart';
//models
import '../models/chat.dart';
import '../models/chat_message.dart';
//providers
import '../providers/chats_page_provider.dart';
import '../providers/authentication_provider.dart';
class ChatPage extends StatefulWidget{
  final Chat chat;
  ChatPage({
    required this.chat
});
  @override
  State<StatefulWidget> createState() {
    return ChatPageState();
  }
}
class ChatPageState extends State<ChatPage>{
  late double _deviceHeight,_deviceWidth;
  late AuthenticationProvider _auth;
  late GlobalKey<FormState> _messageFormState;
  late ScrollController _messageListViewController;
  @override
  Widget build(BuildContext context) {
 return _buildUi();
  }
  Widget _buildUi()
  {
    return Scaffold();
  }
}