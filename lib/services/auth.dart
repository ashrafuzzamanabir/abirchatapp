import 'package:abirchatapp/modal/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods{

  final FirebaseAuth _auth =FirebaseAuth.instance;

  Userd? _userFromFirebaseUser(User user){
    if (user !=null) {
      return Userd(userId : user.uid);
    } else {
      return null;
    }
  }

  // In the newest version of firebase_auth, the class FirebaseUser was changed to User, and the class
  // AuthResult was changed to UserCredential. Therefore change your code to the following:

  Future signInWithEmailAndPassword(String email,String password) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword
        (email: email, password: password);

      User? firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser!);
    }catch(e){
      print(e.toString());
    }
  }

  Future signUpWithEmailAndPassword(String email,String password) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword
        (email: email, password: password);

      User? firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser!);
    }catch(e){
      print(e.toString());
    }
  }

  Future resetPass(String email) async {
    try{
      return await _auth.sendPasswordResetEmail(email: email);

    }catch(e){
      print(e.toString());
    }
  }
  Future signOut(String email) async {
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
    }
  }

}
