import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:popit/theme.dart';
import 'bubble.dart';

part 'space.g.dart';

@HiveType(typeId: 0)
class Space extends HiveObject {
  @HiveField(0)
  late String name;
  @HiveField(1)
  late String color;
  @HiveField(2)
  late List<Bubble> bubbleList;

  Space({required this.name, required this.color, required this.bubbleList});

  Space.copy(Space other) {
    name = other.name;
    color = other.color;
    bubbleList = List<Bubble>.from(other.bubbleList);
  }

  Space.fromTemplate() {
    name = '';
    Random random = Random();
    int randomNumber = random.nextInt(10);
    color = COLORS.keys.elementAt(randomNumber);
    bubbleList = [];
  }

  MaterialColor get materialColor {
    return COLORS[color] ?? Colors.grey;
  }

  @override
  String toString() {
    return 'Name : $name / Color : $color / Bubble list : $bubbleList';
  }
}
