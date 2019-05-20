import 'package:flutter/material.dart';

///
/// Apply theme data
///
ThemeData applyThemeData(ThemeData basic) {
  return basic.copyWith(
    primaryColor: AppColors.colorThemePrimary[800],
    primaryColorDark: AppColors.colorThemePrimary,
    scaffoldBackgroundColor: Colors.white,
    accentColor: AppColors.colorThemeAccent,
    disabledColor: AppColors.colorDisabled,
    textTheme: applyTextTheme(basic.textTheme),
    accentTextTheme: applyTextTheme(basic.accentTextTheme),
    primaryTextTheme: applyTextTheme(basic.primaryTextTheme),
  );
}

TextTheme applyTextTheme(TextTheme basic) {
  return basic.apply(fontFamily: "Roboto");
}

///
/// App Colors
///
class AppColors {
//  static const Color colorPrimary = const Color(0xff0091D0);
//  static const Color colorAccent = const Color(0xff63B226);
  static const Color colorDisabled = const Color(0xffD9D9D9);
  static const Color colorWarning = const Color(0xffFD9A00);
  static const Color colorBlue = const Color(0xff003DFF);
  static const Color colorFacebook = const Color(0xff3B5998);
  static const Color colorSeparator = const Color(0x809b9b9b);
  static const Color colorSeparator24 = const Color(0x3d9b9b9b);
  static const Color colorYoutube = const Color(0xffc4302b);
  static const Color colorBlack = const Color(0xff4a4a4a);

  static const MaterialColor colorThemePrimary = MaterialColor(
    _colorPrimary,
    <int, Color>{
      50: Color(0xFFe9edf5),
      100: Color(0xFFcad3de),
      200: Color(0xFFaab5c5),
      300: Color(0xFF8a98ab),
      400: Color(0xFF728398),
      500: Color(0xFF5a6e86),
      600: Color(0xFF4d6076),
      700: Color(0xFF3e4d5f),
      800: Color(0xFF2f3b4a),
      900: Color(_colorPrimary),
    },
  );
  static const int _colorPrimary = 0xff1d2733;

  static const MaterialColor colorThemeAccent = MaterialColor(
    _colorAccent,
    <int, Color>{
      50: Color(0xFFfbe9e7),
      100: Color(0xFFffccbb),
      200: Color(0xFFffab90),
      300: Color(0xFFfe8a63),
      400: Color(0xFFfe7041),
      500: Color(0xFFfe571e),
      600: Color(0xFFf3511a),
      700: Color(0xFFe54a15),
      800: Color(_colorAccent),
      900: Color(0xFFbe3507),
    },
  );
  static const int _colorAccent = 0xffd74211;

  static const Color colorCardView = const Color(0xff232e3c);
}

///
/// App Images
///
class AppImages {
  static const String bgWelcomeCover = "res/imgs/bg_welcome_cover.jpg";
}
