import 'package:chatt/core/app_color.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context,String content){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content,style: Theme.of(context).textTheme.bodySmall),backgroundColor: AppColors.secondaryColor,));
}