import 'package:chatt/core/app_color.dart';
import 'package:chatt/features/chat/models/chat_model.dart';
import 'package:chatt/features/chat/provider/chat_provider.dart';
import 'package:chatt/helper/snack_bar.dart';
import 'package:chatt/services/local_db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatDetail extends StatefulWidget {
  final ChatModel chatModel;
   ChatDetail({super.key,required this.chatModel});

  @override
  State<ChatDetail> createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  //controller
  final messageController = TextEditingController();

  @override 
  void initState(){
    context.read<ChatProvider>().fetchChatDetail(widget.chatModel.chatId!);
    super.initState();
  }
  
  bool checkIfMessageIsMine(String? id){
    return id == LocalStorage.getUserInfo()!.userId!;
  }
  
 //Controller
 ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
  WidgetsBinding.instance.addPostFrameCallback((_){
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  });
    
    
    return Scaffold(
      appBar: AppBar(title: Text(widget.chatModel.receiver!),),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height*0.78,
                child: Consumer<ChatProvider>(
                  builder: (BuildContext context, ChatProvider value, Widget? child) { 
                    return ListView.builder(
                    controller: scrollController,
                    itemCount: value.messagesList.length,
                    itemBuilder: (context,index){
                      checkIfMessageIsMine(value.messagesList[index].senderId) ? null : value.markAsRead(widget.chatModel.chatId!,value.messagesList[index].messageId!);
                    return Row(
                      mainAxisAlignment: checkIfMessageIsMine(value.messagesList[index].senderId) ? MainAxisAlignment.end : MainAxisAlignment.start,
                      children: [
                        value.messagesList[index].senderId == null ? Container() :
                        Container(
                          margin: const EdgeInsets.all(4),
                          padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 0),
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.6,
                          decoration: checkIfMessageIsMine(value.messagesList[index].senderId) ?
                                      BoxDecoration(
                                        color: AppColors.mainColor,
                                        borderRadius: BorderRadius.circular(10)
                                      )
                                      : BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: AppColors.borderColor
                                      ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(value.messagesList[index].message ?? "",style: const TextStyle(color: Colors.white),),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                                DateFormat().format(DateTime
                                                      .fromMillisecondsSinceEpoch(value
                                                          .messagesList[index]
                                                          .time!
                                                          .millisecondsSinceEpoch)).toString(),style: const TextStyle(color: Colors.white,fontSize: 8),),
                                          
                                          !checkIfMessageIsMine(value.messagesList[index].senderId) ? const SizedBox() :
                                          value.messagesList[index].isRead! ?
                                          Image.asset("assets/icons/check-mark.png",height: 30,fit: BoxFit.fill,)
                                          : const Icon(Icons.done,size: 20,color: Color.fromARGB(255, 223, 220, 220),)
                                        ],
                                      )
                                    ],
                                  ),
                                        ),
                      ],
                    );});
                  
                   },
                  
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: messageController,
                decoration:  InputDecoration(
                  hintText: "Type something",
                  suffixIcon: 
                  GestureDetector(
                    onTap: (){
                      context.read<ChatProvider>().sendMessage(widget.chatModel.chatId!, LocalStorage.getUserInfo()!.userId!, messageController.text, Timestamp.fromDate(DateTime.now()), false).then((val){
                        if(val==200){
                          messageController.clear();
                        }
                      }).catchError((error){
                        showSnackBar(context, "$error");
                      });
                    },
                    child: const Icon(Icons.send,color: AppColors.secondaryColor,))
                ),
                
              ),
            )
          ]),
        ),
      ),
    );
  }
}