import 'dart:async';
import 'dart:developer';

import 'package:chatt/features/chat/models/chat_model.dart';
import 'package:chatt/features/chat/models/message_model.dart';
import 'package:chatt/services/local_db.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ChatProvider with ChangeNotifier{
  
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  
  late StreamSubscription chatsStream ;
  

  //Collection Names
  final String chatCollection = "chats";
  final String messageCollection = "message";
  final String userCollection = "users";

  List<ChatModel> chatsList = [];

  Future fetchChats() async {
    String lastMessage = "";
    try{
     _firebaseFirestore.collection(chatCollection).snapshots().listen((data) async {
      //  String chatId = _firebaseFirestore.collection(chatCollection).id;
    log("$data");
    chatsList.clear();
    await Future.forEach(data.docs, (element) async {
       
        if(element.data()['members'].toList().contains(LocalStorage.getUserInfo()!.userId!)){
          chatsList.add(ChatModel.fromJson(
          {
            "lastMessage": element.data()['lastMessage'],
            "members": element.data()['members'],
            "chatId" : element.id,
            "receiver": element.data()['receiver'] ?? "",
          }
          )
        );
        }
        
    });
    log("chat list is $chatsList");
    notifyListeners();
    // data.docs.forEach((element) async {
        
    //    });
      
     });
    }
    catch(e){
      rethrow;
    }
  }
  


  
  Future<int> sendMessage(String chatId,String senderId,String message,Timestamp time,bool isRead) async {
    try{
      await _firebaseFirestore
          .collection(chatCollection)
          .doc(chatId).update({"lastMessage": message});
      await _firebaseFirestore
          .collection(chatCollection)
          .doc(chatId)
          .collection(messageCollection)
          .add({
        "senderId": senderId,
        "message": message,
        "isRead": isRead,
        "time": time,
      });
      fetchChats();
      return 200;
    }
    catch(e){
      print("e");
      rethrow;
    }
  }
 
  List<MessageModel> messagesList = []; 

  Future fetchChatDetail(String chatId) async {
    try{
      _firebaseFirestore.collection(chatCollection).doc(chatId).collection(messageCollection).orderBy("time").snapshots().listen((messages) async {
        log("message is ${messages.docs}");
        messagesList.clear();
        await Future.forEach(messages.docs, (element)  {
           messagesList.add(
            MessageModel.fromJson(element.data(),element.id)
          );
        }
        );
        log("messages are $messagesList");
        // messagesList=messagesList.toList();
        notifyListeners();
      });
    }
    catch(e){
      print("$e");
      rethrow;
    }
  }

  Future addNewChat(String receiver,String sender) async {
    String receiverName = await getUserName(receiver);
    final response  = await _firebaseFirestore.collection(chatCollection).add({
      "members":[receiver,sender],
      "lastMessage": "",
      "receiver": receiverName
    });
    _firebaseFirestore.collection(chatCollection).doc(response.id).collection(messageCollection).add({});
    fetchChats();
  }

  Future<String> getUserName(String uid) async {
     final response  = await _firebaseFirestore.collection(userCollection).doc(uid).get();
     return response.data()!['name'];
  }

  // String getReceiverId(List<dynamic> members){
  //   int index = members.indexWhere((element)=> element == LocalStorage.getUserInfo()!.userId!);
  //   members.removeAt(index);
  //   return members[0];
  // }

  Future markAsRead(String chatId,String messageId) async {
    await _firebaseFirestore.collection(chatCollection).doc(chatId).collection(messageCollection).doc(messageId).update({"isRead": true});
  }

}