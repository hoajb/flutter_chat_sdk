import 'package:flutter/material.dart';

import 'ui/login.dart';
import 'ui/page/chats_my.dart';
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
      home: LoginScreen(),
      routes: <String, WidgetBuilder>{
        '/main': (BuildContext context) => ChatsMy(),
        '/detail': (BuildContext context) => ChatsMy(),
      },
    );
  }
}
