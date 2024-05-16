import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'Categories.dart';
import 'auth/login.dart';
import 'auth/register.dart';
import '/Home.dart';
import 'models/taskProvider.dart';
import 'models/providerCategory.dart';
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseOptions fireBaseOptions=FirebaseOptions(appId:"1:597765263929:android:010b18690a8a41655673e8",
      apiKey:"AIzaSyBCUJX5NxTfjxWp8T7Q0AsRmxspuGZ2Sqs",
      projectId:"taskmanagement-48354",
      messagingSenderId:"597765263929",
      storageBucket:'taskmanagement-48354.appspot.com');
  await Firebase.initializeApp(options:fireBaseOptions

  );


  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => taskProvider()),
          ChangeNotifierProvider(create: (context) => CategoryProvider()),
        ],

        child: MyApp(),
      )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print(
            '================================== User is currently signed out!');
      } else {
        print('================================== User is signed in!');
      }
    });

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirebaseAuth.instance.currentUser != null
          ? Homepage()
          : Login(),
      routes: {
        "signup" : (context) => SignUp() ,
        "login" : (context) => Login(),
        "home":(context)=>Homepage(),
        "Categories":(context)=>Categories(),
      },
    );
  }
}
