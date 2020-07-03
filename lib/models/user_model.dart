import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserModel extends Model{

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;
  GoogleSignIn _googleSignIn = new GoogleSignIn();

  //utilizador atual

  bool isLoading = false;
  List<int> fonemasList;

  void signIn()async{
    try{
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken, 
          accessToken: googleSignInAuthentication.accessToken,
      );  

      AuthResult result = (await _auth.signInWithCredential(credential));
    
      user = result.user;
      verificaFonemas();
      notifyListeners();

    }catch(error){
      return null;
    }
  }

  void signOut()async{
    await _auth.signOut().then((onValue){
      _googleSignIn.signOut();
    });

    user = null;
    notifyListeners();
  }

  bool isLoggedIn(){
    return user != null;
  }

  void _onSuccess(){
    
  }

  //caso o utilizador inicie sessão pela primeira vez, são criados fonemas na base 
  //  de dados com o uid do user
  void verificaFonemas()
  {
    var docRef = Firestore.instance.collection("fonemas").document(user.uid);

    docRef.get().then((document){
      if(document.exists){
        print("existe");
      }
      else
      {
        Firestore.instance.collection("fonemas").document(user.uid).setData({'fonemas': [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]});
      }
    });
  }

}