import 'package:cloud_firestore/cloud_firestore.dart';
enum MessageType{
  TEXT,IMAGE,UNKNOWN
}
class ChatMessage{
  final String senderID,content;
  final MessageType type;
  final DateTime sentTime;
  ChatMessage({
    required this.content,
    required this.senderID,
    required this.type,
    required this.sentTime,
});
  factory ChatMessage.fromJSON(Map<String , dynamic> _json)
  {
    MessageType _messageType;
    switch(_json["type"])
    {
      case "text":
        _messageType=MessageType.TEXT;
        break;
      case "image":
        _messageType=MessageType.IMAGE;
        break;
      default:
        _messageType=MessageType.UNKNOWN;
    }
    return ChatMessage(content: _json["content"], senderID: _json["sender_id"], type: _messageType, sentTime: _json["sent_time"].toDate(),);
  }
  Map<String,dynamic> toJSON()
  {
    String _messageType;
    switch(type){
      case MessageType.TEXT:
        _messageType="text";
        break;
      case MessageType.IMAGE:
        _messageType="image";
        break;
      default:
        _messageType="";

    }
    return {
      "content":content,
      "type":_messageType,
      "sender_id":senderID,
      "sent_time":Timestamp.fromDate(sentTime),
    };
  }
}