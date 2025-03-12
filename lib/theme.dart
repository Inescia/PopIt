// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';

final Map<String, MaterialColor> COLORS = {
  'blue': Colors.blue,
  'purple': Colors.deepPurple,
  'pink': Colors.pink,
  'red': Colors.red,
  'salmon': Colors.deepOrange,
  'orange': Colors.orange,
  'amber': Colors.amber,
  'green': Colors.green,
  'teal': Colors.teal,
  'brown': Colors.brown,
};

MaterialColor getColorByIndex(int index) {
  if (index < 0 || index >= COLORS.length) return Colors.grey;
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
      primary: Colors.grey.shade700,
      onPrimary: Colors.white,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.grey.shade600,
        foregroundColor: Colors.white,
        shape: const CircleBorder()),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
