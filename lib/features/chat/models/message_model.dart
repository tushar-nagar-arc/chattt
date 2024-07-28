import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel{
  String? message;
  Timestamp? time;
  bool? isRead;
  String? senderId;
  String? messageId;

  MessageModel({
    required this.message,
    required this.isRead,
    required this.senderId,
    required this.time,
    required this.messageId,
  });

  MessageModel.fromJson(Map<String,dynamic> map,String id){
    message = map['message'];
    time = map['time'];
    isRead = map['isRead'];
    senderId = map['senderId'];
    messageId = id;
  }

}