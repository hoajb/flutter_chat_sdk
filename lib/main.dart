import 'package:flutter/material.dart';
import 'package:flutter_chat_sdk/ui/conversation/chat.dart';

import 'ui/login.dart';
import 'ui/page/main_page.dart';
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
        '/main': (BuildContext context) => MainPage(),
//        '/chat': (BuildContext context) => Chat(),
      },
    );
  }
}
