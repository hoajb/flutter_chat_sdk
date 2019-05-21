import 'package:flutter/material.dart';
import 'package:flutter_chat_sdk/widget/bottom_navy_bar.dart';

import '../../tab_navigator.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  int _selectedIndex = TabType.chat;
  PageController _pageController;

  final navigatorKey = GlobalKey<NavigatorState>();

//  HomeBloc _homeBloc;

  /// keys for each tab
  final Map<int, GlobalKey<NavigatorState>> navigatorKeys = {
    TabType.chat: GlobalKey<NavigatorState>(),
    TabType.people: GlobalKey<NavigatorState>(),
    TabType.account: GlobalKey<NavigatorState>(),
    TabType.setting: GlobalKey<NavigatorState>()
  };

  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(initialPage: 0, keepPage: true, viewportFraction: 1.0);
  }

  void _onItemTapped(int index) {
//    _pageController.animateToPage(index,
//        duration: kTabScrollDuration, curve: Curves.easeInOut);

    setState(() {
      _selectedIndex = index;
    });
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
      ),
//      body: PageView(
//        children: <Widget>[
//          _buildOffstageNavigator(TabType.chat),
//          _buildOffstageNavigator(TabType.people),
//          _buildOffstageNavigator(TabType.account),
//          _buildOffstageNavigator(TabType.setting),
//        ],
//        controller: _pageController,
//        onPageChanged: _onPageChanged,
//      ),

      body: Stack(
        children: <Widget>[
          _buildOffstageNavigator(TabType.chat),
          _buildOffstageNavigator(TabType.people),
          _buildOffstageNavigator(TabType.account),
          _buildOffstageNavigator(TabType.setting),
        ],
      ),
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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
