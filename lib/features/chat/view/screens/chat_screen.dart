import 'dart:developer';
import 'package:chatt/core/app_color.dart';
import 'package:chatt/features/chat/provider/chat_provider.dart';
import 'package:chatt/features/chat/view/screens/app_drawer.dart';
import 'package:chatt/features/chat/view/screens/chat_detail.dart';
import 'package:chatt/features/users/view/screens/user_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  
  @override
  void initState(){
    context.read<ChatProvider>().fetchChats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.mainColor,
        child: const Icon(Icons.chat_bubble,color: Colors.white,),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => UsersList()));
        }
      ),
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text("Chats"),),
      body: Consumer<ChatProvider>(
        builder: (context,value,child){
          return ListView.builder(
            itemCount: value.chatsList.length,
            itemBuilder: (context,index){
            return ListTile(
            
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChatDetail(chatModel: value.chatsList[index])));
              },
              leading: const CircleAvatar(
                    backgroundColor: AppColors.secondaryColor,
                    child: Icon(Icons.chat_bubble),
                    ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value.chatsList[index].receiver ?? "",style: Theme.of(context).textTheme.titleSmall,),
                  value.chatsList[index].lastMessage == null || value.chatsList[index].lastMessage!.isEmpty   ? 
                  Text("You may start chatting",style: TextStyle(color: Colors.grey.shade400,fontSize: 10),) :
                  Text(value.chatsList[index].lastMessage!,style: Theme.of(context).textTheme.bodySmall,),
                ],
              ),
            );
          }
         );
        }
      )
    );
  }
}