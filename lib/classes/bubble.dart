import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:popit/theme.dart';

part 'bubble.g.dart';

const bubbleTypeList = ['punctual', 'daily', 'weekly', 'monthly'];

@HiveType(typeId: 1)
class Bubble extends HiveObject {
  @HiveField(0)
  late String name;
  @HiveField(1)
  late String color;
  @HiveField(2)
  late String type;

  Bubble({required this.name, required this.color, required String type})
      : type = bubbleTypeList.contains(type) ? type : bubbleTypeList[0];

  Bubble.copy(Bubble other)
      : name = other.name,
        color = other.color,
        type = other.type;

  Bubble.fromTemplate() {
    name = '';
    Random random = Random();
    int randomNumber = random.nextInt(10);
    color = COLORS.keys.elementAt(randomNumber);
    type = bubbleTypeList[0];
  }

  MaterialColor get materialColor {
    return COLORS[color] ?? Colors.grey;
  }

  @override
  String toString() {
    return 'Name : $name / Type : $type / Color : $color';
  }
}
