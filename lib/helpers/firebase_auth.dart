import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthFirebase{

  /* final GoogleSignIn googleSignIn = GoogleSignIn();

  FirebaseUser _currentUser;

  Future<FirebaseUser> _getUser() async{
    //Verifica se existe um utilizador logado
    if(_currentUser != null) return _currentUser;
    

    try{
      final GoogleSignInAccount googleSignInAccount = 
        await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = 
        await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken, 
        accessToken: googleSignInAuthentication.accessToken,
      );

      final AuthResult authResult = 
        await FirebaseAuth.instance.signInWithCredential(credential);

      final FirebaseUser user = authResult.user;
      return user;
    }catch(error){
      return null;
    }
  } */

  //Youtube channel
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _user;
  GoogleSignIn _googleSignIn = new GoogleSignIn();


  bool isSignIn = false;

  Future<void> handleSignIn() async{
    try{
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken, 
          accessToken: googleSignInAuthentication.accessToken,
      );  

      AuthResult result = (await _auth.signInWithCredential(credential));
    
      _user = result.user;

      isSignIn = true;

    }catch(error){
      return null;
    }
  }

  Future<String> getName() async{
    return _user.displayName;
  }

  Future<void> googleSignOut()async{
    await _auth.signOut().then((onValue){
      _googleSignIn.signOut();
    });
    isSignIn = false;
  }

}