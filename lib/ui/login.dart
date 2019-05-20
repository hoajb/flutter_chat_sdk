import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../tab_navigator.dart';
import 'page/chats_my.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: MaterialButton(
            child: Text("Login by Google"),
            onPressed: () {
              _handleSignIn();
            },
          ),
        ),
      ),
    );
  }

  void _gotoMain() {
    Navigator.pushNamed(
      context, TabNavigatorRoutes.main,
//                  arguments: MovieCategoryPageArguments(
//                      movies: movieList.childrenMovies, title: movieList.title)
    );
  }

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = await _auth.signInWithCredential(credential);
    print("signed in " + user.displayName);

    Route route = MaterialPageRoute(builder: (context) => ChatsMy());
    Navigator.push(context, route);
    return user;
  }

  void _registerUser(String email, String pass) async {
    final FirebaseUser user = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: pass,
    );

//    final FirebaseUser user2 = await _auth.currentUser();
  }
}
