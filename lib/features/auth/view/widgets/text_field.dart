import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isObscure;
  const CustomTextField({super.key,this.isObscure=false, required this.hintText, required this.controller,});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        obscureText: isObscure,
        validator: (val){
          if(val == null || val.toString().trim().isEmpty){
            return "$hintText is missing";
          }
          else if(hintText == "Email") {
            if(!EmailValidator.validate(val)){
              return "Email is invalid";
            }
            else {
              return null;
            }
          }
          else if(hintText == "Password"){
            if(val.toString().trim().length < 6){
              return "Password is too short";
            }
            else{
              return null;
            }
          }
          else{
            return null;
          }
        },
        decoration: InputDecoration(
          hintText: hintText
      ),
    );
  }

}