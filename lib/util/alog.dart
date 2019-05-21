import 'package:flutter/material.dart';
import 'package:flutter_chat_sdk/resource/app_resources.dart';
import 'package:logging/logging.dart';
import 'package:fluttertoast/fluttertoast.dart';

export 'alog.dart';

class Alog {
  static final String defaultClassName = 'TheMovies';
//  static final log = Logger(defaultClassName);

  //init first
  static void init() {
//    Logger.root.level = Level.OFF; // OFF for release

    Logger.root.level = Level.ALL; // defaults to Level.INFO
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    });
  }

  static void debug(Object object) {
    Logger log = Logger(defaultClassName);
    log.info(object);
//    print(object);
  }

  static void showToast(String mess){
    Fluttertoast.showToast(
        msg: mess,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: AppColors.colorThemeAccent[400],
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}
