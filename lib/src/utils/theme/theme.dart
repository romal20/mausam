import 'package:flutter/material.dart';  // Importing the Flutter material library
import 'package:mausam/src/utils/theme/widget_themes/elevated_button_theme.dart';  // Importing custom elevated button theme
import 'package:mausam/src/utils/theme/widget_themes/outlined_button_theme.dart';  // Importing custom outlined button theme
import 'package:mausam/src/utils/theme/widget_themes/text_field_theme.dart';  // Importing custom text field theme
import 'package:mausam/src/utils/theme/widget_themes/text_theme.dart';  // Importing custom text theme

// TAppTheme class for defining the light and dark themes of the app
class TAppTheme {
  TAppTheme._();  // Private constructor

  // Light theme configuration
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,  // Brightness of the theme
    textTheme: TTextTheme.lightTextTheme,  // Text theme
    outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,  // Outlined button theme
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,  // Elevated button theme
    inputDecorationTheme: TextFormFieldTheme.lightInputDecorationTheme,  // Text form field theme
  );

  // Dark theme configuration
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,  // Brightness of the theme
    textTheme: TTextTheme.darkTextTheme,  // Text theme
    outlinedButtonTheme: TOutlinedButtonTheme.darkOutlinedButtonTheme,  // Outlined button theme
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,  // Elevated button theme
    inputDecorationTheme: TextFormFieldTheme.darkInputDecorationTheme,  // Text form field theme
  );
}
