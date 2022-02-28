import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData lightThem() => ThemeData(
    primarySwatch: Colors.lightBlue,
    appBarTheme:  const AppBarTheme(
      titleTextStyle: TextStyle(
        color:Colors.blue,
        fontWeight: FontWeight.w800,
        fontSize: 26,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      color: Colors.white,
      elevation: 2,
    ),
    scaffoldBackgroundColor: Colors.grey[200],
    fontFamily: 'Signika',
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey[700],
    ));
