import 'dart:async';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  var numTask = 0;

  @override
  void initState() {
    super.initState();
    startTime();
//    downloadConfig();
    startAnimFadeLogo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Center(
        child: FadeTransition(
          opacity: animation,
          child: FractionallySizedBox(
              widthFactor: 0.3, child: Image.asset('images/ic_logo.png')),
        ),
      ),
    ));
  }

  startTime() async {
    numTask++;
    return Timer(Duration(milliseconds: 3000), startMainPage);
  }

  startAnimFadeLogo() {
    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    controller.forward();
  }

  downloadConfig() async {
    numTask++;
    startMainPage();
  }

  startMainPage() {
    numTask--;
    if (numTask <= 0) {
      Navigator.of(context).pushReplacementNamed('/main');
    }
  }
}
