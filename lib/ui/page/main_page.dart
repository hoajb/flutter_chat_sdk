import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_sdk/resource/app_resources.dart';
import 'package:flutter_chat_sdk/ui/page/people.dart';
import 'package:flutter_chat_sdk/ui/page/setting.dart';
import 'package:flutter_chat_sdk/util/alog.dart';
import 'package:flutter_chat_sdk/widget/bottom_navy_bar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../tab_navigator.dart';
import '../splashscreen.dart';
import 'account.dart';
import 'history_chat.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  SharedPreferences prefs;
  int _selectedIndex = TabType.chat;
  PageController _pageController;
  bool isLoading = false;

  _MainPageState();

  final navigatorKey = GlobalKey<NavigatorState>();

//  HomeBloc _homeBloc;

  /// keys for each tab
  final Map<int, GlobalKey<NavigatorState>> navigatorKeys = {
    TabType.chat: GlobalKey<NavigatorState>(),
    TabType.people: GlobalKey<NavigatorState>(),
    TabType.account: GlobalKey<NavigatorState>(),
    TabType.setting: GlobalKey<NavigatorState>()
  };

  List<Choice> choices = const <Choice>[
    const Choice(title: 'Settings', icon: Icons.settings),
    const Choice(title: 'Log out', icon: Icons.exit_to_app),
  ];

  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(initialPage: 0, keepPage: true, viewportFraction: 1.0);
  }

  void _onItemTapped(int index) {
    _pageController.animateToPage(index,
        duration: kTabScrollDuration, curve: Curves.easeInOut);

//    setState(() {
//      _selectedIndex = index;
//    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildOffstageNavigator(int tab) {
    return Offstage(
        offstage: _selectedIndex != tab,
        child: TabNavigator(
//          homeBloc: _homeBloc,
          navigatorKey: navigatorKeys[tab],
          currentTab: tab,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat SDK'),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<Choice>(
            onSelected: onItemMenuPress,
            itemBuilder: (BuildContext context) {
              return choices.map((Choice choice) {
                return PopupMenuItem<Choice>(
                    value: choice,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          choice.icon,
                          color: AppColors.colorThemeAccent,
                        ),
                        Container(
                          width: 10.0,
                        ),
                        Text(
                          choice.title,
                          style: TextStyle(color: AppColors.colorThemeAccent),
                        ),
                      ],
                    ));
              }).toList();
            },
          ),
        ],
      ),
      body: WillPopScope(
        child: PageView(
          children: <Widget>[
            HistoryChat(),
            People(),
            Account(),
            Setting(),
          ],
          controller: _pageController,
          onPageChanged: _onPageChanged,
        ),
        onWillPop: onBackPress,
      ),
//      body: WillPopScope(
//        child: Stack(
//          children: <Widget>[
//            _buildOffstageNavigator(TabType.chat),
//            _buildOffstageNavigator(TabType.people),
//            _buildOffstageNavigator(TabType.account),
//            _buildOffstageNavigator(TabType.setting),
//          ],
//        ),
//        onWillPop: onBackPress,
//      ),
      bottomNavigationBar: BottomNavyBar(
        items: [
          BottomNavyBarItem(
              icon: Icon(Icons.message),
              title: Text('Chat'),
              activeColor: Colors.blue,
              inactiveColor: Colors.grey),
          BottomNavyBarItem(
              icon: Icon(Icons.people),
              title: Text('People'),
              activeColor: Colors.blue,
              inactiveColor: Colors.grey),
          BottomNavyBarItem(
              icon: Icon(Icons.account_box),
              title: Text('Account'),
              activeColor: Colors.blue,
              inactiveColor: Colors.grey),
          BottomNavyBarItem(
              icon: Icon(Icons.settings),
              title: Text('Settings'),
              activeColor: Colors.blue,
              inactiveColor: Colors.grey),
        ],
        selectedIndex: _selectedIndex,
        showElevation: true,
        onItemSelected: _onItemTapped,
      ),
    );
  }

  Future<Null> handleSignOut() async {
    this.setState(() {
      isLoading = true;
    });
    var success = false;
    var errorString = '';
    try {
      await FirebaseAuth.instance.signOut();
      await _googleSignIn.disconnect();
      await _googleSignIn.signOut();

      success = true;
    } on PlatformException catch (error) {
      errorString = error.message;
    }

    this.setState(() {
      isLoading = false;
    });
    if (success)
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => SplashScreen()),
          (Route<dynamic> route) => false);
    else {
      Alog.showToast(errorString);
    }
  }

  void onItemMenuPress(Choice choice) {
    if (choice.title == 'Log out') {
      handleSignOut();
    } else {
//      Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()));

      Alog.showToast("Menu click - " + choice.title);
    }
  }

  Future<bool> onBackPress() {
    openDialog();
    return Future.value(false);
  }

  Future<Null> openDialog() async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding:
                EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0, bottom: 0.0),
            children: <Widget>[
              Container(
                color: AppColors.colorThemePrimary,
                margin: EdgeInsets.all(0.0),
                padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
                height: 100.0,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.exit_to_app,
                        size: 30.0,
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.only(bottom: 10.0),
                    ),
                    Text(
                      'Exit app',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Are you sure to exit app?',
                      style: TextStyle(color: Colors.white70, fontSize: 14.0),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 0);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.cancel,
                        color: AppColors.colorThemeAccent,
                      ),
                      margin: EdgeInsets.only(right: 10.0),
                    ),
                    Text(
                      'CANCEL',
                      style: TextStyle(
                          color: AppColors.colorThemeAccent,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 1);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.check_circle,
                        color: AppColors.colorThemeAccent,
                      ),
                      margin: EdgeInsets.only(right: 10.0),
                    ),
                    Text(
                      'YES',
                      style: TextStyle(
                          color: AppColors.colorThemeAccent,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ],
          );
        })) {
      case 0:
        break;
      case 1:
        exit(0);
        break;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}
