import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_sdk/bloc/app/app_bloc.dart';
import 'package:flutter_chat_sdk/resource/app_resources.dart';
import 'package:flutter_chat_sdk/util/alog.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/app/user.dart';
import '../tab_navigator.dart';
import 'page/main_page.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  SharedPreferences _prefs;
  AppBloc _appBloc;

  TextEditingController _controllerPass;
  TextEditingController _controllerRePass;
  TextEditingController _controllerEmail;

  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePass = FocusNode();
  final FocusNode _focusNodeRePass = FocusNode();

  String _email = '';
  String _pass = '';
  String _rePass = '';

  bool _isEmailError = false;
  bool _isPassError = false;
  bool _isRePassError = false;

  bool _isLoginForm = true;

  @override
  void initState() {
    super.initState();
    readLocal();

    _focusNodeEmail.addListener(() {
      _resetErrorState();
    });

    _focusNodePass.addListener(() {
      _resetErrorState();
    });

    _focusNodeRePass.addListener(() {
      _resetErrorState();
    });
  }

  void _resetErrorState() {
    setState(() {
      _isEmailError = false;
      _isPassError = false;
      _isRePassError = false;
    });
  }

  void readLocal() async {
    _prefs = await SharedPreferences.getInstance();
    _email = _prefs.getString('remember_email') ?? '';

    _controllerEmail = TextEditingController(text: _email);
    _controllerPass = TextEditingController(text: '');

    // Force refresh input
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _appBloc = BlocProvider.of<AppBloc>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Container(
//                color: Colors.brown,
                child: _isLoginForm ? _buildLoginForm() : _buildRegisterForm(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      SizedBox(
          width: 120, height: 120, child: Image.asset('images/ic_logo.png')),
      SizedBox(
        height: 15.0,
      ),
      TextField(
        keyboardType: TextInputType.emailAddress,
        maxLines: 1,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(15.0),
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                const Radius.circular(15.0),
              ),
            ),
            filled: true,
            labelText: 'Email',
            errorText: _isEmailError ? 'Required*' : null,
            fillColor: Colors.white70),
        controller: _controllerEmail,
        onChanged: (value) {
          _email = value;
        },
        focusNode: _focusNodeEmail,
      ),
      SizedBox(
        height: 15.0,
      ),
      TextField(
        keyboardType: TextInputType.text,
        obscureText: true,
        maxLines: 1,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(15.0),
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                const Radius.circular(15.0),
              ),
            ),
            filled: true,
            labelText: 'Password',
            errorText: _isPassError ? 'Required*' : null,
            fillColor: Colors.white70),
        controller: _controllerPass,
        onChanged: (value) {
          _pass = value;
        },
        focusNode: _focusNodePass,
      ),
      SizedBox(
        height: 15.0,
      ),
      ButtonTheme(
        minWidth: 150.0,
        height: 40.0,
        child: RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          color: Theme.of(context).accentColor,
          splashColor: AppColors.colorSeparator,
          child: Text(
            "Login".toUpperCase(),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold
//                            shadows: [
//                              Shadow(
//                                blurRadius: 5.0,
//                                color: Colors.white,
//                                offset: Offset(1.0, 1.0),
//                              ),
//                            ],
                ),
          ),
          onPressed: () {
            if (_email.trim().isEmpty) {
              setState(() {
                _isEmailError = true;
              });
              return;
            }

            if (_pass.isEmpty) {
              setState(() {
                _isPassError = true;
              });
              return;
            }

            _focusNodeEmail.unfocus();
            _focusNodePass.unfocus();

            _handleSignInByEmail();
          },
        ),
      ),
      SizedBox(
        height: 15.0,
      ),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SignInButton(
            Buttons.Google,
            mini: true,
            onPressed: () {
              _handleSignInGoogle();
            },
          ),
          SizedBox(
            width: 5.0,
          ),
          SignInButton(
            Buttons.Facebook,
            mini: true,
            onPressed: () {
              _handleSignInByFB();
            },
          ),
          SizedBox(
            width: 5.0,
          ),
          SignInButton(
            Buttons.Twitter,
            mini: true,
            onPressed: () {
              _handleSignInByTwitter();
            },
          ),
        ],
      ),
      SizedBox(
        height: 15.0,
      ),
      MaterialButton(
        child: Text(
          "Create account",
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.normal,
            shadows: [
              Shadow(
                blurRadius: 10,
                color: Colors.blue,
                offset: Offset(1.0, 1.0),
              ),
            ],
          ),
        ),
        onPressed: () {
          setState(() {
            _isLoginForm = false;
          });
        },
      )
    ]);
  }

  Widget _buildRegisterForm() {
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      SizedBox(
          width: 120, height: 120, child: Image.asset('images/ic_logo.png')),
      SizedBox(
        height: 15.0,
      ),
      TextField(
        keyboardType: TextInputType.emailAddress,
        maxLines: 1,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(15.0),
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                const Radius.circular(15.0),
              ),
            ),
            filled: true,
            labelText: 'Email',
            errorText: _isEmailError ? 'Required*' : null,
            fillColor: Colors.white70),
        controller: _controllerEmail,
        onChanged: (value) {
          _email = value;
        },
        focusNode: _focusNodeEmail,
      ),
      SizedBox(
        height: 15.0,
      ),
      TextField(
        keyboardType: TextInputType.text,
        obscureText: true,
        maxLines: 1,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(15.0),
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                const Radius.circular(15.0),
              ),
            ),
            filled: true,
            labelText: 'Password',
            errorText: _isPassError ? 'Required*' : null,
            fillColor: Colors.white70),
        controller: _controllerPass,
        onChanged: (value) {
          _pass = value;
        },
        focusNode: _focusNodePass,
      ),
      SizedBox(
        height: 15.0,
      ),
      TextField(
        keyboardType: TextInputType.text,
        obscureText: true,
        maxLines: 1,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(15.0),
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                const Radius.circular(15.0),
              ),
            ),
            filled: true,
            labelText: 'Re-Enter Password',
            errorText: _isRePassError ? 'Required*' : null,
            fillColor: Colors.white70),
        controller: _controllerRePass,
        onChanged: (value) {
          _rePass = value;
        },
        focusNode: _focusNodeRePass,
      ),
      SizedBox(
        height: 15.0,
      ),
      ButtonTheme(
        minWidth: 150.0,
        height: 40.0,
        child: RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          color: Theme.of(context).accentColor,
          splashColor: AppColors.colorSeparator,
          child: Text(
            "Register".toUpperCase(),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            if (_email.trim().isEmpty) {
              setState(() {
                _isEmailError = true;
              });
              return;
            }

            if (_pass.isEmpty) {
              setState(() {
                _isPassError = true;
              });
              return;
            }

            if (_rePass.isEmpty) {
              setState(() {
                _isRePassError = true;
              });
              return;
            }

            _focusNodeEmail.unfocus();
            _focusNodePass.unfocus();
            _focusNodeRePass.unfocus();

            _handleRegisterByEmail();
          },
        ),
      ),
      SizedBox(
        height: 15.0,
      ),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SignInButton(
            Buttons.Google,
            mini: true,
            onPressed: () {
              _handleSignInGoogle();
            },
          ),
          SizedBox(
            width: 5.0,
          ),
          SignInButton(
            Buttons.Facebook,
            mini: true,
            onPressed: () {
              _handleSignInByFB();
            },
          ),
          SizedBox(
            width: 5.0,
          ),
          SignInButton(
            Buttons.Twitter,
            mini: true,
            onPressed: () {
              _handleSignInByTwitter();
            },
          ),
        ],
      ),
      SizedBox(
        height: 15.0,
      ),
      MaterialButton(
        child: Text(
          "Back to Login",
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.normal,
            shadows: [
              Shadow(
                blurRadius: 10,
                color: Colors.blue,
                offset: Offset(1.0, 1.0),
              ),
            ],
          ),
        ),
        onPressed: () {
          setState(() {
            _isLoginForm = true;
          });
        },
      )
    ]);
  }

  void _gotoMain() {
    Navigator.pushNamed(
      context, TabNavigatorRoutes.main,
//                  arguments: MovieCategoryPageArguments(
//                      movies: movieList.childrenMovies, title: movieList.title)
    );
  }

  Future<FirebaseUser> _handleSignInGoogle() async {
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
      Route route = MaterialPageRoute(builder: (context) => MainPage());
      _storeUser(user);
      Alog.showToast("Sign in success");
      Navigator.push(context, route);
    } else {
      Alog.showToast("Sign in fail");
    }
    return user;
  }

  _storeUser(FirebaseUser firebaseUser) async {
    _prefs = await SharedPreferences.getInstance();
    if (firebaseUser != null) {
      // Check is already sign up
      final QuerySnapshot result = await Firestore.instance
          .collection('users')
          .where('id', isEqualTo: firebaseUser.uid)
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      UserChat userChat;
      if (documents.length == 0) {
        // Update data to server if new user
        Firestore.instance
            .collection('users')
            .document(firebaseUser.uid)
            .setData({
          'nickname': firebaseUser.displayName ?? firebaseUser.email ?? '',
          'photoUrl': firebaseUser.photoUrl ?? '',
          'id': firebaseUser.uid
        });

        await _prefs.setString('id', firebaseUser.uid);
        await _prefs.setString(
            'nickname', firebaseUser.displayName ?? firebaseUser.email ?? '');
        await _prefs.setString('photoUrl', firebaseUser.photoUrl ?? '');
        userChat = UserChat(firebaseUser.displayName, firebaseUser.photoUrl,
            firebaseUser.uid, "", "" /*dateCreated*/);
      } else {
        await _prefs.setString('id', documents[0]['id']);
        await _prefs.setString('nickname', documents[0]['nickname'] ?? '');
        await _prefs.setString('photoUrl', documents[0]['photoUrl'] ?? '');
        await _prefs.setString('aboutMe', documents[0]['aboutMe'] ?? '');

        userChat = UserChat(documents[0]['nickname'], documents[0]['photoUrl'],
            documents[0]['id'], documents[0]['aboutMe'], "" /*dateCreated*/);
      }

      UserSignInEvent event = UserSignInEvent(userInfo: userChat);
      _appBloc.dispatch(event);
    }
  }

  Future<FirebaseUser> _handleSignInByEmail() async {
    try {
      final FirebaseUser user = await _auth
          .signInWithEmailAndPassword(email: _email, password: _pass)
          .timeout(Duration(seconds: 30));

      if (user != null) {
        print("signed in " + user.displayName);
        Route route = MaterialPageRoute(builder: (context) => MainPage());
        _storeUser(user);
        Alog.showToast("Sign in success");
        Navigator.push(context, route);
      } else {
        Alog.showToast("Sign in fail");
      }
      return user;
    } on PlatformException catch (error) {
      Alog.debug(error);
      _handleLoginError(error);
    }
    return null;
  }

  Future<FirebaseUser> _handleSignInByFB() {
    //TODO
  }

  Future<FirebaseUser> _handleSignInByTwitter() {
    //TODO
  }

  Future<FirebaseUser> _handleRegisterByEmail() async {
    try {
      final FirebaseUser user = await _auth
          .createUserWithEmailAndPassword(email: _email.trim(), password: _pass)
          .timeout(Duration(seconds: 30));

      if (user != null) {
//        print("Created in " + user.displayName);
        Route route = MaterialPageRoute(builder: (context) => MainPage());
        _storeUser(user);
        Alog.showToast("Register in success");
        Navigator.push(context, route);
      } else {
        Alog.showToast("Register fail");
      }
      return user;
    } on PlatformException catch (error) {
      Alog.debug(error);
      _handleLoginError(error);
    }
    return null;
  }

  void _handleLoginError(PlatformException e) {
    AuthProblems errorType;
    if (Platform.isAndroid) {
      switch (e.message) {
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
        case 'The email address is badly formatted.':
          errorType = AuthProblems.UserNotFound;
          break;
        case 'The password is invalid or the user does not have a password.':
          errorType = AuthProblems.PasswordNotValid;
          break;
        case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
          errorType = AuthProblems.NetworkError;
          break;
        case 'The email address is already in use by another account.':
          errorType = AuthProblems.EmailDuplicated;
          break;
        // ...
        default:
          print('Case ${e.message} is not jet implemented');
      }
    } else if (Platform.isIOS) {
      switch (e.code) {
        case 'Error 17011':
          errorType = AuthProblems.UserNotFound;
          break;
        case 'Error 17009':
          errorType = AuthProblems.PasswordNotValid;
          break;
        case 'Error 17020':
          errorType = AuthProblems.NetworkError;
          break;
        default:
          errorType = AuthProblems.UnKnown;
          print('Case ${e.message} is not jet implemented');
      }
    }
    print('The error is $errorType');

    switch (errorType) {
      case AuthProblems.UserNotFound:
      case AuthProblems.PasswordNotValid:
        Alog.showToast('Email/Pass is invalid.');
        break;
      case AuthProblems.NetworkError:
        Alog.showToast('Network Error.');
        break;
      case AuthProblems.EmailDuplicated:
        Alog.showToast(
            'The email address is already in use by another account.');
        break;
      case AuthProblems.UnKnown:
        Alog.showToast('UnKnown Error.');
        break;
    }
  }
}

enum AuthProblems {
  UnKnown,
  UserNotFound,
  PasswordNotValid,
  NetworkError,
  EmailDuplicated
}
