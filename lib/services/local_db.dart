import 'dart:developer';

import 'package:chatt/features/auth/models/user_model.dart';
import 'package:hive/hive.dart';

class LocalStorage {
  
  static const String userKey = "userInfo";

  static Future storeUserInfo(UserModel user) async {
    final userBox = Hive.box("user");
    await userBox.put(userKey, user.toJson());
  }

  static UserModel? getUserInfo(){
    final userBox = Hive.box("user");
    log("${userBox.get(userKey)}");
    return userBox.get(userKey) != null ? UserModel.fromJson(userBox.get(userKey)as Map<dynamic,dynamic>) : null;
  }

  static Future clearAll() async {
    final userBox = Hive.box("user");
    await userBox.clear();
  }
}