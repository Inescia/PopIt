// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';

const List<Map<String, dynamic>> COLOR_LIST = [
  {'color': Color(0xFFFF8989), 'legend': 'Tapis, Travail et Pré à faire'},
  {'color': Color(0xFFFFBEBF), 'legend': 'Tapis et Travail à faire'},
  {'color': Color(0xFFFEC27A), 'legend': 'Tapis et Pré à faire'},
  {'color': Color(0xFFFED9B3), 'legend': 'Travail et Pré à faire'},
  {'color': Color(0xFFFBF783), 'legend': 'Tapis à faire'},
  {'color': Color(0xFFFFFDBD), 'legend': 'Travail à faire'},
  {'color': Color(0xFFCFFFD0), 'legend': 'Pré à faire'},
  {'color': Color(0xFFF9F9F9), 'legend': 'Rien à faire'},
];

const List<String> DAY_LIST = [
  'Lundi',
  'Mardi',
  'Mercredi',
  'Jeudi',
  'Vendredi',
  'Samedi',
  'Dimanche'
];

const List<String> VERTICAL_LABEL_LIST = ['', 'Tapis', 'Travail', 'Pré'];
const List<String> HORIZONTAL_LABEL_LIST = ['', ...DAY_LIST];

Text title(String text) {
  return Text(
    text,
    style: const TextStyle(fontSize: 20),
  );
}

ThemeData theme() {
  return ThemeData(
    appBarTheme: const AppBarTheme(
      color: Colors.white,
      centerTitle: false,
      foregroundColor: Colors.black87,
      titleSpacing: 15,
    ),
    fontFamily: 'Avenir',
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.grey,
    ).copyWith(
      primary: Colors.grey.shade800,
      onPrimary: Colors.white,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        shape: CircleBorder()),
    dividerTheme: const DividerThemeData(
      color: Colors.white,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
    }),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
