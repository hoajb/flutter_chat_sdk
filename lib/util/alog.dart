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
}
