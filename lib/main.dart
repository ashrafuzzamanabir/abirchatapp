import 'dart:ffi';

import 'package:abirchatapp/helper/authenticate.dart';
import 'package:abirchatapp/helper/helperfunctions.dart';
import 'package:abirchatapp/views/chatroomscreen.dart';
import 'package:abirchatapp/views/signin.dart';
import 'package:abirchatapp/views/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  // to initialize the freeking firebase code or we will have an error of no app of firebase running
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  late bool userIsLoggedIn;

  void initState(){
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async{
    await HelperFunctions.getUserLoggedInSharedPreference().then((value){
      setState(() {
        userIsLoggedIn = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.indigo,
        primarySwatch: Colors.blue,
      ),
      home: userIsLoggedIn != null ?  userIsLoggedIn ? ChatRoom() : Authenticate()
          : Container(
        child: Center(
          child: Authenticate(),
        ),
      ),
    );
  }
}

class IamBlank extends StatefulWidget {
  const IamBlank({Key? key}) : super(key: key);

  @override
  State<IamBlank> createState() => _IamBlankState();
}

class _IamBlankState extends State<IamBlank> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
