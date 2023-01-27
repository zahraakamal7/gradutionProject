import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Themes {
  static ThemeData _lightTheme = FlexColorScheme.light(
    colors: FlexColor.schemes[FlexScheme.bahamaBlue]!.light,
    surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,

    appBarStyle: FlexAppBarStyle.primary,
    // background:,
    appBarElevation: 10,
    tabBarStyle: FlexTabBarStyle.forAppBar,
    tooltipsMatchBackground: true,
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
  ).toTheme;
  static ThemeData _darkTheme = FlexColorScheme.dark(
    colors: FlexColor.schemes[FlexScheme.bahamaBlue]!.dark,
    appBarElevation: 10,
    tabBarStyle: FlexTabBarStyle.forAppBar,
    tooltipsMatchBackground: true,
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
  ).toTheme;
  static final light = _lightTheme.copyWith(
      dividerColor: _lightTheme.backgroundColor,
      inputDecorationTheme: InputDecorationTheme(),
      textTheme: ThemeData.light()
          .textTheme
          .apply(fontFamily: GoogleFonts.cairo().fontFamily));

  static final dark = _darkTheme.copyWith(
      inputDecorationTheme: InputDecorationTheme(),
      textTheme: ThemeData.dark()
          .textTheme
          .apply(fontFamily: GoogleFonts.cairo().fontFamily));
}
