import 'dart:async';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../Widgets/chatBotmessage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatBOTScreen extends StatefulWidget {
  const ChatBOTScreen({
    Key ? key
  }): super(key: key);
  @override
  State < ChatBOTScreen > createState() => _ChatBOTScreenState();
}
class _ChatBOTScreenState extends State < ChatBOTScreen > {
  final TextEditingController _controller = TextEditingController();
  final List < ChatMessage > _message = [];
  String apiKey = "api-key";
  Future < void > _sendMessage() async {
    ChatMessage message = ChatMessage(text: _controller.text, sender: "user");
    setState(() {
      _message.insert(0, message);
    });
    _controller.clear();
    final response = await generateText(message.text);
    ChatMessage botMessage = ChatMessage(text: response.toString(), sender: "Chatify AI");
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
    return Scaffold(
      // App bar
      appBar: AppBar(centerTitle: true, title: Text("Chatify AI"), ),
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