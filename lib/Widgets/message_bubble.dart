import 'dart:io';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:velocity_x/velocity_x.dart';
//Models
import '../models/chat_message.dart';
import 'package:translator/translator.dart';


class TextMessageBubble extends StatefulWidget {
  final bool isOwnMessage;
  final ChatMessage message;
  final double height, width;
  GoogleTranslator translator = GoogleTranslator();

  TextMessageBubble({
    required this.isOwnMessage,
    required this.message,
    required this.width,
    required this.height,
  });

  @override
  _TextMessageBubbleState createState() => _TextMessageBubbleState();
}

class _TextMessageBubbleState extends State<TextMessageBubble> {
  String _translatedText = '';

  @override
  void initState() {
    super.initState();
    _translateMessage();
  }

  Future<void> _translateMessage() async {
    final translatedText = await widget.translator.translate(
      widget.message.content,
      to: "hi", // Target language (e.g., Hindi)
    );
    setState(() {
      _translatedText = translatedText.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Color> _colorscheme = widget.isOwnMessage
        ? [Color.fromRGBO(0, 136, 249, 1.0), Color.fromRGBO(0, 82, 218, 1.0)]
        : [Color.fromRGBO(51, 49, 68, 1.0), Color.fromRGBO(51, 49, 68, 1.0)];

    return Container(
      height: widget.height + (widget.message.content.length / 10 * 6.0) * 5,
      width: widget.width,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: _colorscheme,
          stops: [0.30, 0.70],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(  widget.message.content,
            style: TextStyle(color: Colors.white),),
          Text(
            _translatedText.isNotEmpty ? _translatedText : widget.message.content,
            style: TextStyle(color: Colors.white),
          ),
          Text(
            timeago.format(widget.message.sentTime),
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class ImageMessageBubble extends StatelessWidget{
  final bool isOwnMessage;
  final ChatMessage message;
  final double height,width;
  ImageMessageBubble({
    required this.isOwnMessage,
    required this.message,
    required this.width,
    required this.height,
  });
  @override
  Widget build(BuildContext context) {
    List<Color> _colorscheme=isOwnMessage? [Color.fromRGBO(0, 136, 249, 1.0),Color.fromRGBO(0, 82, 218, 1.0)]:[Color.fromRGBO(51, 49, 68, 1.0),Color.fromRGBO(51, 49, 68, 1.0)];
    DecorationImage _image=DecorationImage(image: NetworkImage(message.content),fit: BoxFit.cover);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width*0.02,vertical: height*0.03,),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(colors: _colorscheme,stops: [0.30,0.70],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: _image),),
          SizedBox(height: height*0.02,),
          Text(
            timeago.format(message.sentTime),
            style: TextStyle(color: Colors.white70),
          )

        ],
      ),
    );

  }
}




