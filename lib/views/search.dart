import 'package:abirchatapp/helper/constants.dart';
import 'package:abirchatapp/services/database.dart';
import 'package:abirchatapp/views/conversionscreen.dart';
import 'package:abirchatapp/widgets/widget1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:abirchatapp/views/chatroomscreen.dart';
class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  DatabaseMethods databaseMethods =new DatabaseMethods();
  //for searching controll this will be the code
  //late QuerySnapshot searchSnapshot;
  QuerySnapshot <Map<String, dynamic>>? searchSnapshot;
  TextEditingController searchTextEditingController = new TextEditingController();


  bool isLoading = false;
  bool haveUserSearched = false;

  //for search list after the button press
  Widget searchList(){
    return searchSnapshot != null ?  ListView.builder(
      itemCount: searchSnapshot?.docs.length ,
      shrinkWrap: true,
      itemBuilder:(context ,index){
        return SearchTile(
            userName: searchSnapshot?.docs[index].data()!['name'],
            userEmail: searchSnapshot?.docs[index].data()!['email']
        );

      },
    ) : Container();
  }

  //for initiating the search
  initiateSearch() async{
  await databaseMethods.getUserByUsername(searchTextEditingController.text)
      .then((val){
      setState((){
        searchSnapshot =val;
      });
  });
  }

// create chatroom send user conversion screen
  createChatroomAndStartConversion({required String userName}){

   if(userName != Constants.myName){
     String chatRoomId = getChatRoomId(userName,Constants.myName);
     List<String> users = [userName,Constants.myName];
     Map<String,dynamic> chatRoomMap = {
       "users" :users ,
       "chatroomId" : chatRoomId
     };
     DatabaseMethods().createChatRoom(chatRoomId , chatRoomMap);
     Navigator.push(context, MaterialPageRoute(
         builder: (context) =>ConversationScreen()
     ));
   }else{
     print("you can't send massge to you");
   }
  }

  Widget  SearchTile({required String userName,required String userEmail}){
    return Container(
      child: Padding(
        padding: EdgeInsets.all(45),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName, style: simpleTextStyle(),),
                Text(userEmail, style: simpleTextStyle(),),
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: (){
                  createChatroomAndStartConversion(
                      userName: userName
                  );
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(40)
                ),
                padding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                child: Text("massages" , style: midTextStyle(),),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void initState(){
    super.initState();
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchTextEditingController,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: "search username",
                        hintStyle: TextStyle(
                          color: Colors.white54,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: (){
                      initiateSearch();
                    },
                    child: Container(
                      height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0x36FFFFFF),
                              const Color(0x0FFFFFFF)
                            ],
                          ),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Image.asset("assets/images/search_white.png")
                    ),
                  ),
                ],
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }
}


getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}