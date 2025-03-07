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

  Bubble({required this.name, required this.color, required this.type});

  Bubble.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    color = json['color'];
    type = json['type'];
  }

  Bubble.fromTemplate() {
    name = '';
    color = 'blue';
    type = bubbleTypeList[0];
  }

  Bubble.copy(Bubble other) {
    name = other.name;
    color = other.color;
    type = other.type;
  }

  dynamic operator [](String key) {
    switch (key) {
      case 'name':
        return name;
      case 'color':
        return color;
      case 'type':
        return type;
      default:
        throw Exception('Propriété non trouvée');
    }
  }

  void operator []=(String key, dynamic value) {
    switch (key) {
      case 'name':
        name = value;
        break;
      case 'color':
        color = value;
        break;
      case 'type':
        type = value;
        break;
      default:
        throw Exception('Propriété non trouvée');
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, String> data = <String, String>{};
    data['name'] = name;
    data['color'] = color;
    data['type'] = type;
    return data;
  }

  MaterialColor get materialColor {
    return COLORS[color] ?? Colors.grey;
  }

  @override
  String toString() {
    return 'Name : $name / Type : $type / Color : $color';
  }
}
