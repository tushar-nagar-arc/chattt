
import 'package:flutter/foundation.dart';

class UserModel{
  String? name;
  String? email;
  String? userId;
  String? profile;

  UserModel({required this.email,required this.name,required this.userId,required this.profile});
   
  UserModel.fromJson(Map<dynamic,dynamic> map){
    name = map['name'];
    email = map['email'];
    userId = map['user_id'];
    profile = map['profile'];
  }

  Map<String,dynamic> toJson(){
    return {
      "name":name!,
      "email":email!,
      "user_id":userId!,
      "profile": profile
    };
  }
  
}