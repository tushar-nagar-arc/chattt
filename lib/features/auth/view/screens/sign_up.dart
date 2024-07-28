import 'dart:io';

import 'package:chatt/features/auth/providers/auth.dart';
import 'package:chatt/features/auth/view/widgets/text_field.dart';
import 'package:chatt/features/chat/view/screens/chat_screen.dart';
import 'package:chatt/helper/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  //controllers
  final emailController = TextEditingController();

  final nameController = TextEditingController();

  final paswordController = TextEditingController();

  //FormKey
  final _formKey = GlobalKey<FormState>();

  //file image
  File? fileImage;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child:  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Sign Up",style: Theme.of(context).textTheme.titleLarge,),
                  const SizedBox(height: 20,),
                   Stack(
                     children: [
                       CircleAvatar(
                        radius: 50,
                        backgroundImage: fileImage != null ? FileImage(fileImage!,) : const AssetImage("assets/icons/female.png"),
                        ),
                        Positioned(
                          bottom: 10,
                          right: 0,
                          child:  GestureDetector(
                            onTap: () async {
                              XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
                              if(file != null){
                                if(context.mounted){
                                
                                
                                setState(() {
                                  fileImage = File(file.path);
                                });
                                
                              }
                              }
                            },
                            child: const Icon(Icons.camera_alt)))
                     ],
                   ),
                  const SizedBox(height: 20,),
                  CustomTextField(hintText: "Name", controller: nameController),
                  const SizedBox(height: 20,),
                  CustomTextField(hintText: "Email", controller: emailController),
                  const SizedBox(height: 20,),
                  CustomTextField(hintText: "Password", controller: paswordController),
                  const SizedBox(height: 20,),
                  Consumer<AuthProvider>(
                    builder: (context,value,child) {
                      return 
                      value.isLoading ? const Center(child: CircularProgressIndicator()) :
                      ElevatedButton(onPressed: (){
                        if(_formKey.currentState!.validate()){
                          value.signUp(emailController.text, paswordController.text, nameController.text,fileImage)
                          .then((val){
                              val == 200 ? Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) => const ChatScreen())
                              ) : null;
                            })
                          .catchError((error){
                          showSnackBar(context, "$error");
                        });
                        }
                      }, child: const Text("Sign Up"));
                    }
                  ),
                  const SizedBox(height: 20,),
                  TextButton(onPressed: (){
                      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => SignUp()));
                    }, child: const Text("Back to login"),),
                ],
              ),
            )
          ),
        ),
      ),
    );
  }
}