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

  Space.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    color = json['color'];
    bubbleList = json['bubbleList'];
  }

  Space.fromTemplate() {
    name = '';
    color = 'blue';
    bubbleList = [];
  }

  Space.copy(Space other) {
    name = other.name;
    color = other.color;
    bubbleList = other.bubbleList;
  }

  dynamic operator [](String key) {
    switch (key) {
      case 'name':
        return name;
      case 'color':
        return color;
      case 'bubbleList':
        return bubbleList;
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
      case 'bubbleList':
        bubbleList = value;
        break;
      default:
        throw Exception('Propriété non trouvée');
    }
  }

  MaterialColor get materialColor {
    return COLORS[color] ?? Colors.grey;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['color'] = color;
    data['bubbleList'] = bubbleList;
    return data;
  }

  @override
  String toString() {
    return 'Name : $name / Color : $color / Bubble list : $bubbleList';
  }
}
