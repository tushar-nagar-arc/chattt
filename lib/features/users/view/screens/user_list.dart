import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatt/features/auth/models/user_model.dart';
import 'package:chatt/features/chat/provider/chat_provider.dart';
import 'package:chatt/features/users/providers/user_provider.dart';
import 'package:chatt/helper/snack_bar.dart';
import 'package:chatt/services/local_db.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsersList extends StatefulWidget {
  const UsersList({super.key});

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {

  @override   
  void initState(){
    fetchUser = context.read<UserProvider>().fetchUsers();
    super.initState();
  }
 
 late Future fetchUser;
  
  List<UserModel> userList = [];
  List<UserModel> searchList = [];
  
  final searchController = TextEditingController();
 
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Users"),),
      body: FutureBuilder(
        future: fetchUser, 
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }
          else if(snapshot.connectionState == ConnectionState.done){
            userList.clear();
            userList.addAll(searchList.isNotEmpty 
                  ? searchList
                  : searchList.isEmpty && searchController.text.isNotEmpty ? []
                  : context.read<UserProvider>().usersList) ;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: searchController,
                    decoration: const InputDecoration(hintText: "Search"),
                    onChanged: (val)  {
                          searchList.clear();
                          searchList.addAll(context
                              .read<UserProvider>()
                              .usersList
                              .where((element) => element.name!.contains(val)));

                         
                        setState(() {
                           
                        });
                    }
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                  itemCount: userList.length,
                  itemBuilder: (context, index) {
                      return ListTile(
                        onTap: (){
                          showDialog(
                            context: context, 
                            builder: (context){
                              return AlertDialog(
                                title: Text("Ready to chat ?"),
                                actions: [
                                  TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Cancel")),
                                  TextButton(onPressed: (){
                                    
                                    WidgetsBinding.instance.addPostFrameCallback((_){
                                      context
                                                  .read<ChatProvider>()
                                                  .addNewChat(
                                                      userList[index].userId!,
                                                      LocalStorage
                                                              .getUserInfo()!
                                                          .userId!)
                                                  .then((_) {
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              });
                                    });
                                   
                                    
                                  }, child: const Text("Continue")),
                                  
                                ],
                              );
                            });
                          
                        },
                        leading:  CircleAvatar(
                          backgroundImage: userList[index].profile != null 
                                ? 
                                userList[index].profile == "" ?
                                const AssetImage("assets/icons/female.png") :
                                CachedNetworkImageProvider(userList[index].profile!)
                                : const AssetImage("assets/icons/female.png"),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(userList[index].name!),
                            Text(userList[index].email!)
                          ],
                        ),
                      );
                    
                    
                  }),
                ),
            ]);
          }
          else if(snapshot.hasError){
            return Text("${snapshot.error}");
          }
          else{
            return const Text("No data found");
          }
        },
      ) 
    );
  }
}