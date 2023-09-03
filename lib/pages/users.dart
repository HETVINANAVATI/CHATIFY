import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
class usersPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
   return _userPageState();
  }

}
class _userPageState extends State<usersPage>
{
   @override
  Widget build(BuildContext context) {
    return _buildUi();
  }
  Widget _buildUi()
  {
    return Scaffold(
      backgroundColor: Colors.green,
    );
  }
}