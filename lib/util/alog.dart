import 'package:logging/logging.dart';

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
//    Fluttertoast.showToast(
//        msg: "This is Center Short Toast",
//        toastLength: Toast.LENGTH_SHORT,
//        gravity: ToastGravity.CENTER,
//        timeInSecForIos: 1,
//        backgroundColor: Colors.red,
//        textColor: Colors.white,
//        fontSize: 16.0
//    );
  }
}
