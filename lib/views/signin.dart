import 'package:abirchatapp/helper/helperfunctions.dart';
import 'package:abirchatapp/services/auth.dart';
import 'package:abirchatapp/services/database.dart';
import 'package:abirchatapp/views/chatroomscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:abirchatapp/widgets/widget1.dart';


class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);


  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final formkey = GlobalKey<FormState>();
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();

  bool isLoading = false;
  QuerySnapshot <Map<String, dynamic>>? snapshotUserInfo;

  SignMeIn() async {
    if(formkey.currentState!.validate()) {
      HelperFunctions.getUserEmailSharedPreference(emailTextEditingController.text);

    setState(() {
      isLoading = true;
    });
    databaseMethods.getUserByUserEmail(emailTextEditingController.text)
      .then((val) {
        snapshotUserInfo =val;
        HelperFunctions
            .getUserEmailSharedPreference(
            snapshotUserInfo?.docs[0].data()['name']);
    });
    await authMethods.signUpWithEmailAndPassword(
       emailTextEditingController.text,
       passwordTextEditingController.text).then((val) async{
      if(val != null){

        HelperFunctions.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => const ChatRoom()));
      }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: SingleChildScrollView(

        child: Container(
          height: MediaQuery.of(context).size.height-50,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min ,
              children: [
               Form(
                 key: formkey,
                 child: Column(
                   children: [
                     TextFormField(
                       validator: (val){
                         return RegExp(
                             r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                             .hasMatch(val!)
                             ? null
                             : "Please Enter Correct Email";
                       },
                       controller:emailTextEditingController,
                       style: simpleTextStyle(),
                       decoration: textFieldInputDecoration("Email"),
                     ),
                     TextFormField(
                       obscureText: true,
                       validator: (val){
                         return val!.length >6 ? null : "plase provide more then 6 characters";
                       },
                       controller: passwordTextEditingController,
                       style: simpleTextStyle(),
                       decoration: textFieldInputDecoration("Password"),
                     ),
                   ],
                 ),
               ),
                const SizedBox(height: 8,),
                Container(
                  alignment: Alignment.centerRight,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                      child: Text("Forgot Password? ",style: simpleTextStyle(),),
                    )
                ),
                const SizedBox(height: 8,),
                GestureDetector(
                  onTap: (){
                    SignMeIn();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xff007EF4),
                            const Color(0xff2A75BC)
                          ],
                        )),
                    child: Text("Sign In" ,style: TextStyle(
                      color:Colors.white,
                      fontSize: 17
                    )
                    ),
                  ),
                ),
                SizedBox(height: 8,),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                     color: Colors.white,
                      ),
                  child: Text("Sign In with Google" ,style: TextStyle(
                      color:Colors.black,
                      fontSize: 17
                  )
                  ),
                ),
                SizedBox(height: 16,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? ", style: midTextStyle(),),
                    GestureDetector(
                      onTap: (){
                        widget.toggle();

                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text("Register NOW", style: unmidTextStyle(),
                          )
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }
}
