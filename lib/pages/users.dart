import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
//provider
import '../providers/authentication_provider.dart';
import '../providers/users_page_provider.dart';
//widget
import '../Widgets/top_bar.dart';
import  '../Widgets/custom_input_fields.dart';
import '../Widgets/custom_list_view_tiles.dart';
import '../Widgets/rounded_button.dart';
//models
import '../models/chat_user.dart';
class usersPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
   return _userPageState();
  }

}
class _userPageState extends State<usersPage>
{
  late double _deviceWidth,_deviceHeight;
  late AuthenticationProvider _auth;
  late UsersPageProvider _pageProvider;
  final TextEditingController _searchFieldTextEditingController=TextEditingController();
   @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<UsersPageProvider>(create: (_)=>UsersPageProvider(_auth)),

    ],child: _buildUi(),);
  }
  Widget _buildUi()
  {
    _deviceHeight=MediaQuery.of(context).size.height;
    _deviceWidth=MediaQuery.of(context).size.width;
    _auth=Provider.of<AuthenticationProvider>(context);

    return Builder(builder: (BuildContext _context){
      _pageProvider=_context.watch<UsersPageProvider>();
      return Container(
        padding: EdgeInsets.symmetric(horizontal: _deviceWidth*0.03,vertical: _deviceHeight*0.02),
        height: _deviceHeight*0.98,
        width: _deviceHeight*0.97,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TopBar('Users',
              primaryAction:IconButton(icon: Icon(Icons.logout,color: Color.fromRGBO(0, 82, 218, 1.0)),onPressed:(){
                _auth.logout();
              } ,),
            ) ,
            CustomTextField(onEditingComplete:(_value){
              _pageProvider.getUsers(name: _value);
              FocusScope.of(context).unfocus();
            }, hintText: 'Search...', obscureText: false, controller:  _searchFieldTextEditingController,icon: Icons.search,),
            _usersList(),
            _createChatButton(),
          ],
        ),
      );
    });
  }
  Widget _usersList() {
     List<ChatUser>? _users=_pageProvider.users;

    return Expanded(child: () {
      if(_users!=null){
        if(_users.length!=0){
          return ListView.builder(
              itemCount: _users.length, itemBuilder: (BuildContext _context, int _index) {
            return CustomListViewTile(
                height: _deviceHeight*0.10,
                title: _users[_index].name,
                subtitle: "Last Active: ${_users[_index].lastDayActive()}"
                , imagePath: _users[_index].imageURL,
                isActive: _users[_index].wasRecentlyActive(),
                isSelected: _pageProvider.selectedUser.contains(_users[_index]),
                onTap: (){
                  _pageProvider.updateSelectedUsers(_users[_index]);
                }
            );
          });
        }
        else
          {
            return Center(child:
            Text("No Users Found.",style: TextStyle(color:Colors.white ),),
            );
          }

      }
      else
        {
          return Center(child: CircularProgressIndicator(color: Colors.white,),);
        }

    }());
  }
  Widget _createChatButton()
  {
    return Visibility(
      visible: _pageProvider.selectedUser.isNotEmpty,
        child: RoundedButton(
          name: _pageProvider.selectedUser.length==1?
          "Chat With ${_pageProvider.selectedUser.first.name}":
          "Create Group Chat",
          height: _deviceHeight*0.08,
          width: _deviceWidth*0.80,
          onPressed: (){
      _pageProvider.createChat();
    },),
    );
  }
}

