import 'dart:async';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../Widgets/chatBotmessage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Widgets/top_bar.dart';
class ChatBOTScreen extends StatefulWidget {
  const ChatBOTScreen({
    Key ? key,
  }): super(key: key);
  @override
  State < ChatBOTScreen > createState() => _ChatBOTScreenState();
}
class _ChatBOTScreenState extends State < ChatBOTScreen > {
  late double _deviceHeight;
  late double _deviceWidth;
  final TextEditingController _controller = TextEditingController();
  final List < ChatMessage > _message = [];
  String apiKey = "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";
  Future < void > _sendMessage() async {
    ChatMessage message = ChatMessage(text: _controller.text, sender: "user",size: _deviceHeight*0.05,);
    setState(() {
      _message.insert(0, message);
    });
    _controller.clear();
    final response = await generateText(message.text);
    ChatMessage botMessage = ChatMessage(size:_deviceHeight*0.05,text: response.toString(), sender: "Chatify AI");
    setState(() {
      _message.insert(0, botMessage);
    });
  }
  Future < String > generateText(String prompt) async {
    try {
      Map < String, dynamic > requestBody = {
        "model": "text-davinci-003",
        "prompt": prompt,
        "temperature": 0,
        "max_tokens": 100,
      };
      var url = Uri.parse('https://api.openai.com/v1/completions');
      var response = await http.post(url, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey"
      }, body: json.encode(requestBody));
      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body);
        return responseJson["choices"][0]["text"];
      } else {
        return "Failed to generate text: ${response.body}";
      }
    } catch (e) {
      return "Failed to generate text: $e";
    }
  }
  Widget _buidTextComposer() {
    return Row(children: [
      Expanded(child: TextField(controller: _controller, decoration: InputDecoration.collapsed(hintText: "Send a message"), ), ),
      IconButton(onPressed: () {
        _sendMessage();
      }, icon: Icon(Icons.send))
    ], ).px12();
  }
  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Chatify AI"),iconTheme: IconThemeData(color: Color.fromRGBO(0, 82, 218, 1.0)),
        backgroundColor: Color.fromRGBO(36, 35, 49, 1.0),
       ),
      // body
      body: SafeArea(child: Column(children: [
        Flexible(child: ListView.builder(padding: Vx.m8, reverse: true, itemBuilder: (context, index) {
          return _message[index];
        }, itemCount: _message.length, )),
        Divider(height: 1, ),
        Container(decoration: BoxDecoration(), child: _buidTextComposer(), )
      ], ), ), );
  }
}