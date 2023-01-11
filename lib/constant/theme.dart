import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pssi/constant/colors.dart';

class MyTheme {
  static ThemeData general = ThemeData(
      brightness: Brightness.light,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: GoogleFonts.openSansTextTheme(),
      backgroundColor: backgroundColor,
      scaffoldBackgroundColor: backgroundColor,
      bottomSheetTheme:
          const BottomSheetThemeData(backgroundColor: backgroundColor),
      fontFamily: 'Roboto',
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            color: primaryColor,
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        color: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        foregroundColor: Colors.white,
        actionsIconTheme: const IconThemeData(
          color: Colors.white,
        ),
        toolbarTextStyle: const TextTheme(
          headline1: TextStyle(
            fontSize: 10,
          ),
          headline2: TextStyle(fontSize: 12),
          headline3: TextStyle(
            fontSize: 14,
          ),
          headline4: TextStyle(
            fontSize: 16,
          ),
          headline5: TextStyle(
            fontSize: 18,
          ),
          headline6: TextStyle(
            fontSize: 20,
          ),
        ).bodyText2,
        titleTextStyle: const TextTheme(
          headline1: TextStyle(
            fontSize: 10,
            color: Colors.black,
          ),
          headline2: TextStyle(
            fontSize: 12,
            color: Colors.black,
          ),
          headline3: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
          headline4: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
          headline5: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
          headline6: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ).headline6,
        elevation: 0,
      ),
      expansionTileTheme: const ExpansionTileThemeData(
        textColor: primaryColor,
        iconColor: primaryColor,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: primaryColor,
        unselectedItemColor: primaryColor.withOpacity(0.4),
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(
          fontSize: 11,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 11,
        ),
      ),
      primaryIconTheme: const IconThemeData(
        color: Colors.white,
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: primaryColor,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: primaryColor,
          ),
        ),
        iconColor: primaryColor,
        suffixIconColor: primaryColor,
        floatingLabelStyle: TextStyle(
          color: primaryColor,
        ),
      ),
      tabBarTheme: const TabBarTheme(
        labelColor: primaryColor,
        indicator: UnderlineTabIndicator(
            borderSide: BorderSide(color: primaryColor, width: 2)),
        unselectedLabelColor: Colors.grey,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
        ),
      ),
      textSelectionTheme:
          const TextSelectionThemeData(cursorColor: primaryColor),
      // switchTheme: SwitchThemeData(),
      primaryColor: primaryColor,
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return primaryColor.withOpacity(.32);
          }
          return primaryColor;
        }),
      ));

  static ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: GoogleFonts.openSansTextTheme(),
    backgroundColor: const Color(0xff1b1c1e),
    scaffoldBackgroundColor: const Color(0xff1b1c1e),
    bottomSheetTheme:
        const BottomSheetThemeData(backgroundColor: backgroundColor),
    fontFamily: 'Roboto',
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          color: primaryColor,
        ),
      ),
    ),
    appBarTheme: AppBarTheme(
      color: const Color(0xff1b1c1e),
      centerTitle: true,
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      foregroundColor: Colors.white,
      actionsIconTheme: const IconThemeData(
        color: Colors.white,
      ),
      toolbarTextStyle: const TextTheme(
        headline1: TextStyle(
          fontSize: 10,
        ),
        headline2: TextStyle(fontSize: 12),
        headline3: TextStyle(
          fontSize: 14,
        ),
        headline4: TextStyle(
          fontSize: 16,
        ),
        headline5: TextStyle(
          fontSize: 18,
        ),
        headline6: TextStyle(
          fontSize: 20,
        ),
      ).bodyText2,
      titleTextStyle: const TextTheme(
        headline1: TextStyle(
          fontSize: 10,
          color: Colors.black,
        ),
        headline2: TextStyle(
          fontSize: 12,
          color: Colors.black,
        ),
        headline3: TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
        headline4: TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
        headline5: TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
        headline6: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ).headline6,
      elevation: 0,
    ),
    expansionTileTheme: const ExpansionTileThemeData(
      textColor: primaryColor,
      iconColor: primaryColor,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: primaryColor,
      unselectedItemColor: primaryColor.withOpacity(0.4),
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: const TextStyle(
        fontSize: 11,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 11,
      ),
    ),
    primaryIconTheme: const IconThemeData(
      color: Colors.white,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: primaryColor,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: primaryColor,
        ),
      ),
      iconColor: primaryColor,
      suffixIconColor: primaryColor,
      floatingLabelStyle: TextStyle(
        color: primaryColor,
      ),
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: primaryColor,
      indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: primaryColor, width: 2)),
      unselectedLabelColor: Colors.grey,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
      ),
    ),
    textSelectionTheme: const TextSelectionThemeData(cursorColor: primaryColor),
    // switchTheme: SwitchThemeData(),
    primaryColor: primaryColor,
    checkboxTheme: CheckboxThemeData(
      fillColor:
          MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return primaryColor.withOpacity(.32);
        }
        return primaryColor;
      }),
    ),
    listTileTheme: const ListTileThemeData(
      textColor: Colors.white,
    ),
  );
}
