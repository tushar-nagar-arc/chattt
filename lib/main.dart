import 'dart:io';

import 'package:chatt/core/app_theme.dart';
import 'package:chatt/features/auth/providers/auth.dart';
import 'package:chatt/features/auth/view/screens/sign_in.dart';
import 'package:chatt/features/chat/provider/chat_provider.dart';
import 'package:chatt/features/chat/view/screens/chat_screen.dart';
import 'package:chatt/features/users/providers/user_provider.dart';
import 'package:chatt/services/local_db.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid || Platform.isIOS ? await Firebase.initializeApp() :
  await Firebase.initializeApp(options: const FirebaseOptions(
    apiKey: "AIzaSyB1gjXmOqHAeiFmN_cpmFy2Tnft8d4CTzg", 
    appId: "1:316019405619:web:6c034d79d3497cd52cc446", 
    messagingSenderId: "316019405619", 
    projectId: "chatt-c3840"
    )
  );
  await Hive.initFlutter();
  await Hive.openBox("user");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
         ChangeNotifierProvider(create: (context) => ChatProvider()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: AppTheme.theme,
          home: LocalStorage.getUserInfo() != null ? const ChatScreen() : SignIn(),
      ),
    );
  }
}
