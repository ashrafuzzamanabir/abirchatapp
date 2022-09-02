import 'package:flutter/material.dart';

class appBarMain extends StatelessWidget implements PreferredSizeWidget {
  //app bar issue sloved after this
  appBarMain(BuildContext context);

  @override
  Size get preferredSize => const Size.fromHeight(60);

  Widget build(BuildContext context) {
    return AppBar(
      title: Image.asset(
        "assets/images/logo.png",
        height: 40,
      ),
      elevation: 0.0,
      centerTitle: false,
    );
  }
}

InputDecoration textFieldInputDecoration(String hintText) {
    return InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white54),
        focusedBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        enabledBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)));
}

TextStyle simpleTextStyle(){
  return TextStyle(
    color:Colors.white,
    fontSize: 16,
  );
}

TextStyle midTextStyle() {
  return TextStyle(color: Colors.white, fontSize: 17);
}

TextStyle unmidTextStyle() {
  return TextStyle(
      color: Colors.white,
      fontSize: 17 ,
      decoration: TextDecoration.underline
  );
}