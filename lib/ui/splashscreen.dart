import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _user;
  var _numTask = 0;

  @override
  void initState() {
    super.initState();
    _startTime();
    _getUserInfo();
//    downloadConfig();
    _startAnimFadeLogo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Center(
        child: FadeTransition(
          opacity: _animation,
          child: FractionallySizedBox(
              widthFactor: 0.3, child: Image.asset('images/ic_logo.png')),
        ),
      ),
    ));
  }

  _startTime() async {
    _numTask++;
    return Timer(Duration(milliseconds: 3000), startMainPage);
  }

  _startAnimFadeLogo() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
  }

  _getUserInfo() async {
    _numTask++;
    _user = await _auth.currentUser();
    startMainPage();
  }

  downloadConfig() async {
    _numTask++;
    startMainPage();
  }

  startMainPage() {
    _numTask--;
    if (_numTask <= 0) {
      if (_user != null && !_user.isAnonymous)
        Navigator.of(context).pushReplacementNamed('/main');
      else
        Navigator.of(context).pushReplacementNamed('/login');
    }
  }
}
