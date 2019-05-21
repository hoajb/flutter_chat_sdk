import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../tab_navigator.dart';
import 'page/main_page.dart';

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

    Route route = MaterialPageRoute(builder: (context) => MainPage());
    _storeUser(user);
    Navigator.push(context, route);
    return user;
  }

  _storeUser(FirebaseUser firebaseUser) async {
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
