import 'package:abirchatapp/helper/helperfunctions.dart';
import 'package:abirchatapp/services/auth.dart';
import 'package:abirchatapp/services/database.dart';
import 'package:abirchatapp/views/chatroomscreen.dart';
import 'package:abirchatapp/widgets/widget1.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  // Form validating key
  final formkey = GlobalKey<FormState>();
  bool isLoading = false;

  AuthMethods authMethods =new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  

  /*controller for fire base connection and test feild*/
  TextEditingController userNameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();

  //sign me up function
  SignMeUp() async{
    if(formkey.currentState!.validate()){
      Map<String ,String> userInfoMap ={
        "name" : userNameTextEditingController.text,
        "email" : emailTextEditingController.text,
      };
      
      HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);
      HelperFunctions.saveUserEmailSharedPreference(userNameTextEditingController.text);

      setState(() {

        isLoading = true;
      });
      authMethods.signUpWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text).then((val){
        print("$val");


        databaseMethods.uploadUserInfo(userInfoMap);
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => const ChatRoom()
        ));
      });
    }
  }


  /*main app design--------------------by abir*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading ? Container(
        child: Center(child: CircularProgressIndicator()),
      ):SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height-50,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min ,
              children: [
               Form(

                 // for validating the form key is provided
                 key: formkey,
                 child: Column(
                   children: [
                     TextFormField(
                       //validator for the field
                       validator: (val){
                         if (val!.isEmpty || val!.length < 3 ) {
                           return "Enter Username 3+ characters";
                         } else {
                           return null;
                         }
                       },
                       //adding controller for text field
                       controller: userNameTextEditingController,
                       style: simpleTextStyle(),
                       decoration: textFieldInputDecoration("UserName"),
                     ),
                     TextFormField(
                       validator: (val){
                         return RegExp(
                             r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                             .hasMatch(val!)
                             ? null
                             : "Please Enter Correct Email";
                       },
                       controller: emailTextEditingController,
                       style: simpleTextStyle(),
                       decoration: textFieldInputDecoration("Email"),
                     ),
                     TextFormField(
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
                SizedBox(height: 8,),
                Container(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                      child: Text("Forgot Password? ",style: simpleTextStyle(),),
                    )
                ),
                SizedBox(height: 8,),
                GestureDetector(
                  onTap: (){
                    SignMeUp();
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
                    child: Text("Sign Up" ,style: TextStyle(
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
                  child: Text("Sign UP with Google" ,style: TextStyle(
                      color:Colors.black,
                      fontSize: 17
                  )
                  ),
                ),
                SizedBox(height: 16,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? ", style: midTextStyle(),),
                    GestureDetector(
                      onTap: (){
                        widget.toggle();
                      },
                      child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text("Sign In now ", style: unmidTextStyle(),
                          )),
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
