import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_sdk/util/alog.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../tab_navigator.dart';
import 'page/main_page.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  SharedPreferences prefs;

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

    if (user != null) {
      Route route = MaterialPageRoute(
          builder: (context) => MainPage(
                currentUserId: user.uid,
              ));
      _storeUser(user);
      Alog.showToast("Sign in success");
      Navigator.push(context, route);
    } else {
      Alog.showToast("Sign in fail");
    }
    return user;
  }

  _storeUser(FirebaseUser firebaseUser) async {
    prefs = await SharedPreferences.getInstance();
    if (firebaseUser != null) {
      // Check is already sign up
      final QuerySnapshot result = await Firestore.instance
          .collection('users')
          .where('id', isEqualTo: firebaseUser.uid)
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 0) {
        // Update data to server if new user
        Firestore.instance
            .collection('users')
            .document(firebaseUser.uid)
            .setData({
          'nickname': firebaseUser.displayName,
          'photoUrl': firebaseUser.photoUrl,
          'id': firebaseUser.uid
        });

        await prefs.setString('id', firebaseUser.uid);
        await prefs.setString('nickname', firebaseUser.displayName);
        await prefs.setString('photoUrl', firebaseUser.photoUrl);
      } else {
        await prefs.setString('id', documents[0]['id']);
        await prefs.setString('nickname', documents[0]['nickname']);
        await prefs.setString('photoUrl', documents[0]['photoUrl']);
        await prefs.setString('aboutMe', documents[0]['aboutMe']);
      }
    }
  }

  void _registerUser(String email, String pass) async {
    final FirebaseUser user = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: pass,
    );

//    final FirebaseUser user2 = await _auth.currentUser();
  }
}
