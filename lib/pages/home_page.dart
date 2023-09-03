import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../pages/chats.dart';
import '../pages/users.dart';
class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
   return HomePageState();
  }
}
class HomePageState extends State<HomePage>{
  int _currentPage=0;
  final List<Widget> _pages=[
    ChatsPage(),
    usersPage(),

  ];
  @override
  Widget build(BuildContext context) {
    return _buildUi();
  }
  Widget _buildUi()
  {
    return Scaffold(
      body: _pages[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
         currentIndex: _currentPage,
        onTap: (_index){
           setState(() {
             _currentPage=_index;
           });
        },
        items: [
          BottomNavigationBarItem(icon:Icon(Icons.chat_bubble_outline_sharp) ,label: "Chats"),
          BottomNavigationBarItem(icon:Icon(Icons.supervised_user_circle_sharp) ,label: "Users"),
        ],
      ),
    );
  }
}