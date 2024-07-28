import 'package:chatt/core/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
   
   static final theme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleTextStyle: TextStyle(fontSize: 18,color: AppColors.blackColor),elevation: 0,shadowColor: Colors.transparent,color: Colors.transparent),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(double.maxFinite, 50),
        foregroundColor: Colors.white,
        backgroundColor: AppColors.mainColor
      )
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(backgroundColor: Colors.transparent,foregroundColor: AppColors.mainColor)
    ),


    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 40,fontWeight: FontWeight.w600),
      titleMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(10),
      hintStyle: const TextStyle(fontSize: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.borderColor),
        borderRadius: BorderRadius.circular(8)
      ),
      focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: AppColors.secondaryColor, width: 2),
              borderRadius: BorderRadius.circular(8))
    )

   );

}