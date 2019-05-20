import 'package:flutter/material.dart';

import 'ui/login.dart';
import 'ui/page/chats_my.dart';
import 'ui/splashscreen.dart';
import 'util/alog.dart';

void main() {
  Alog.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Chat SDK",
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => LoginScreen(),
        '/splash': (BuildContext context) => SplashScreen(),
        '/main': (BuildContext context) => ChatsMy(),
        '/detail': (BuildContext context) => ChatsMy(),
      },
    );
  }
}
