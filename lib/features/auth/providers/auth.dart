import "dart:developer";
import "dart:io";
import "package:chatt/features/auth/models/user_model.dart";
import "package:chatt/services/local_db.dart";
import "package:firebase_storage/firebase_storage.dart";
import 'package:flutter/material.dart';
import "package:firebase_auth/firebase_auth.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class AuthProvider with ChangeNotifier{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  
  final String userCollection = "users";
  UserModel? userModel;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void startLoader(){
    _isLoading=true;
    notifyListeners();
  }

  void stopLoader() {
    _isLoading = false;
    notifyListeners();
  }
  

  //Sign Up
  Future signUp(String email,String password,String name,File? file) async {
    UserModel? userModel ;
    log("email is $email");
    startLoader();
    try{
      final response = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      if(response.user != null){
        String downloadUrl = file != null ?  await uploadImage(file, response.user!.uid) : "";
        await storeUserInDb(response.user!, name, downloadUrl);
        log("user is ${response.user}");
        userModel = UserModel.fromJson({
          "profile": downloadUrl,
          "name":name,
          "email":email,
          "user_id": response.user!.uid,
        });
        await LocalStorage.storeUserInfo(userModel);
        return 200;
      }
    }
    on FirebaseAuthException catch(e) {
      log("$e");
      rethrow;
    }
    catch(e){
      log("$e");
      rethrow;
    }
    finally{
      stopLoader();
    }
  }

  //Sign In
  Future signIn(String email, String password) async {
    UserModel? userModel;
    log("email is $email");
    startLoader();
    try {
      final response = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (response.user != null) {
        log("user is ${response.user}");
        final user = await getUserFromFireStore(response.user!.uid);
        userModel = UserModel.fromJson({
          "name": user!['name'],
          "email": email,
          "user_id": response.user!.uid,
        });
        await LocalStorage.storeUserInfo(userModel);
        return 200;
      }
    } on FirebaseAuthException catch (e) {
      log("$e");
      rethrow;
    } catch (e) {
      log("$e");
      rethrow;
    } finally {
      stopLoader();
    }
  }



  Future storeUserInDb(User user,String name,String url) async {
   try{
    await _firebaseFirestore.collection(userCollection).doc(user.uid).set({
        "user_id": user.uid,
        "name": name,
        "email": user.email,
        "profile": url
    });
   }
   catch(e){
    log("$e");
    rethrow;
   }
  }

  Future<Map<String,dynamic>?> getUserFromFireStore(String uid) async {
    final documentSnapshot = await _firebaseFirestore.collection(userCollection).doc(uid).get();
    return documentSnapshot.data();
  }

  Future<String> uploadImage(File file,String uid) async {
    try{
      final task = await _firebaseStorage.ref("images/user-profile/$uid/").putFile(file);
      return task.storage.ref("images/user-profile/$uid/").getDownloadURL();
    }
    catch(e){
      print("e");
      rethrow;
    }
    
  }
}