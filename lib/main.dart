import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_sdk/bloc/app/app_bloc.dart';

import 'ui/login.dart';
import 'ui/page/main_page.dart';
import 'ui/splashscreen.dart';
import 'util/alog.dart';

void main() {
  Alog.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppBloc _appBlock = AppBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppBloc>(
        bloc: _appBlock,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Chat SDK",
          home: SplashScreen(),
          routes: <String, WidgetBuilder>{
            '/login': (BuildContext context) => LoginScreen(),
            '/splash': (BuildContext context) => SplashScreen(),
            '/main': (BuildContext context) => MainPage(),
//        '/chat': (BuildContext context) => Chat(),
          },
        ));
  }

  @override
  void dispose() {
    _appBlock.dispose();
    super.dispose();
  }
}
