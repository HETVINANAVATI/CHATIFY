import 'package:chatify/pages/chatBotPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import '../providers/authentication_provider.dart';
import '../providers/chats_page_provider.dart';
import '../Widgets/top_bar.dart';
import '../Widgets/custom_list_view_tiles.dart';
import '../models/chat.dart';
import '../models/chat_user.dart';
import '../models/chat_message.dart';
import '../services/navigation_services.dart';
import '../pages/chat_page.dart';
class ChatsPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _ChatsPageState();
  }
}
class _ChatsPageState extends State<ChatsPage>{
  late double _deviceHeight;
  late double _deviceWidth;
  late AuthenticationProvider _auth;
  late ChatsPageProvider _pageProvider;
  late NavigationService _navigationService;
 @override
  Widget build(BuildContext context) {
   _deviceHeight = MediaQuery.of(context).size.height;
   _deviceWidth = MediaQuery.of(context).size.width;
   _auth=Provider.of<AuthenticationProvider>(context);
   _navigationService=GetIt.instance.get<NavigationService>();
    return MultiProvider(providers:
    [
      ChangeNotifierProvider<ChatsPageProvider>(create: (_)=>
        ChatsPageProvider(_auth),
   ),
    ],child: _buildUi(),);
  }
  Widget _buildUi()
  {
    return Builder(builder: (BuildContext _context){
      _pageProvider=_context.watch<ChatsPageProvider>();
      return Container(
        padding: EdgeInsets.symmetric(horizontal: _deviceWidth*0.03,vertical: _deviceHeight*0.02,),
        height: _deviceHeight*0.98,
        width: _deviceWidth*0.97,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TopBar("Chats", primaryAction: IconButton(icon:Icon(
              Icons.logout,
              color: Color.fromRGBO(0, 82, 218, 1.0),),
              onPressed: (){
                _auth.logout();
              },),
            ),
            _chatBot(),
            _chatsList(),
          ],
        ),
      );
    },);
  }
  Widget _chatsList()
  {
    List<Chat>? _chats=_pageProvider.chats;

    return Expanded(child: ((){
      if(_chats!=null)
        {
           if(_chats.length!=0)
             {
                return ListView.builder(itemCount: _chats.length,itemBuilder: (BuildContext _context ,int _index ){
                  return _chatTile(_chats[_index]);
                });
             }
           else
             {
               return Center(child: Text("No Chats Found",style:TextStyle(color: Colors.white),),);
             }
        }
      else
        {
          return Center(child: CircularProgressIndicator(color: Colors.white,),);
        }
    })(),);
  }
  Widget _chatTile(Chat _chat)
  {
    List<ChatUser> _receipents=_chat.receipents();
    bool _isActive = _receipents.any((_d) => _d.wasRecentlyActive());
    String _subtitleText="";
    if(_chat.messages.isNotEmpty)
      {
        _subtitleText=_chat.messages.first.type!=MessageType.TEXT?"Media Attachment":_chat.messages.first.content;
      }
    return  CustomListViewTitleWithActivity(
        height: _deviceHeight*0.10,
        title: _chat.title(),
        subtitle: _subtitleText,
        imagePath: _chat.imageURL(),
        isActive: _isActive,
        isActivity: _chat.activity,
        onTap: (){
          _navigationService.navigateToPage(ChatPage(chat: _chat),
          );
        }
    );
  }
  Widget _chatBot()
  {
    return CustomListViewTile(
        height: _deviceHeight*0.10,
        title: "Chatify AI",
        subtitle: "Your AI friend",
        imagePath: "https://th.bing.com/th/id/OIP.kwJH4fC-iCHuCF2Ar4_vfgHaHa?pid=ImgDet&rs=1",
        isActive: true,
        isSelected: false,
        onTap: (){
          _navigationService.navigateToPage(ChatBOTScreen(key:GlobalKey()));
        });
  }
}
