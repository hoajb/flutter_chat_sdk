import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_sdk/ui/splashscreen.dart';

import 'bloc/app/app_bloc.dart';
import 'ui/page/account.dart';
import 'ui/page/history_chat.dart';
import 'ui/page/people.dart';
import 'ui/page/setting.dart';

class TabType {
  static const chat = 0;
  static const people = 1;
  static const account = 2;
  static const setting = 3;
}

class TabNavigatorRoutes {
  static const String main = '/';
//  static const String movieCategory = 'movieCategory';
}

class TabNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final int currentTab;

//  final HomeBloc homeBloc;

  TabNavigator({
    Key key,
    @required this.navigatorKey,
    @required this.currentTab,
//      @required this.homeBloc
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
        key: navigatorKey,
        initialRoute: TabNavigatorRoutes.main,
        onGenerateRoute: (routeSettings) {
          return _routeForRouteSettings(routeSettings: routeSettings);
        });
  }

  PageRoute _routeForRouteSettings({@required RouteSettings routeSettings}) {
    return MaterialPageRoute(builder: (context) {
      if (routeSettings.name == TabNavigatorRoutes.main) {
        switch (currentTab) {
          case TabType.chat:
//            return HomePage(homeBloc: homeBloc);
            return HistoryChat();
          case TabType.people:
            return People();
          case TabType.account:
            return Account();
          case TabType.setting:
            return Setting();
          default:
            break;
        }
      }

      if (routeSettings.name == '/splash') {
//        final MoviePageArguments args = routeSettings.arguments;
        return SplashScreen();
      }

//      if (routeSettings.name == TabNavigatorRoutes.movieCategory) {
//        final MovieCategoryPageArguments args = routeSettings.arguments;
//        return MovieCategoryPage(movies: args.movies, title: args.title);
//      }
    });
  }
}
