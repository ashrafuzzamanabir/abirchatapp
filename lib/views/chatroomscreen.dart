import 'package:abirchatapp/helper/authenticate.dart';
import 'package:abirchatapp/helper/helperfunctions.dart';
import 'package:abirchatapp/services/auth.dart';
import 'package:abirchatapp/views/search.dart';
import 'package:abirchatapp/views/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:abirchatapp/helper/constants.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  AuthMethods authMethods = new AuthMethods();

  @override
  void initState(){
    getUserInfo();
    super.initState();
  }
  getUserInfo() async{
    Constants.myName = (
        await HelperFunctions.getUserNameSharedPreference(
            HelperFunctions.sharedPreferenceUserNameKey))!;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/images/logo.png",
          height: 40,
        ),
        actions: [
          GestureDetector (
            onTap: () async{
              final FirebaseAuth _auth = FirebaseAuth.instance;
              Future<void> _signOut() async {
                await _auth.signOut();
              }
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => Authenticate()
              ));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.exit_to_app),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => SearchScreen()
          ));
        },
      ),

    );
  }
}
