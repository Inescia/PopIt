// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';

final Map<String, MaterialColor> COLORS = {
  'blue': Colors.blue,
  'red': Colors.red,
  'grey': Colors.grey,
  'orange': Colors.orange,
  'pink': Colors.pink,
  'amber': Colors.amber,
  'purple': Colors.deepPurple,
  'teal': Colors.teal,
  'green': Colors.green,
  'brown': Colors.brown,
};

MaterialColor getColorByIndex(int index) {
  return COLORS.values.elementAt(index);
}

ThemeData theme() {
  return ThemeData(
    appBarTheme: const AppBarTheme(
      color: Colors.transparent,
      centerTitle: false,
      foregroundColor: Colors.black87,
      titleSpacing: 15,
    ),
    fontFamily: 'Avenir',
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.grey,
    ).copyWith(
      primary: Colors.grey.shade600,
      onPrimary: Colors.white,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.grey.shade600,
        foregroundColor: Colors.white,
        shape: const CircleBorder()),
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
    }),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
