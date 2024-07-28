import 'dart:io';

import 'package:chatt/features/auth/providers/auth.dart';
import 'package:chatt/features/auth/view/screens/sign_up.dart';
import 'package:chatt/features/auth/view/widgets/text_field.dart';
import 'package:chatt/features/chat/view/screens/chat_screen.dart';
import 'package:chatt/helper/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignIn extends StatelessWidget {
  SignIn({super.key});

  //controllers
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final paswordController = TextEditingController();

  //FormKey
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Sign In",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(hintText: "Email", controller: emailController),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(hintText: "Password", controller: paswordController),
                    const SizedBox(
                      height: 20,
                    ),
                    Consumer<AuthProvider>(
                      builder: (context,value,child) {
                        return 
                        value.isLoading ?
                        const Center(child: CircularProgressIndicator(),) :
                        ElevatedButton(onPressed: () {
                          if(_formKey.currentState!.validate()){
                            value.signIn(emailController.text,paswordController.text)
                            .then((val){
                              val == 200 ? Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) => const ChatScreen())
                              ) : null;
                            })
                            .catchError((error){
                              showSnackBar(context, "$error");
                            });
                          }
                        }, child: const Text("Sign In")
                      );
                      }
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUp()));
                        },
                        child: const Text("Sign Up")
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
