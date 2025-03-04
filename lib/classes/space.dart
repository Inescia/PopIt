import 'package:flutter/material.dart';
import 'bubble.dart';

final Map<String, MaterialColor> COLORS = {
  'blue': Colors.blue,
  'red': Colors.red,
  'grey': Colors.grey,
  'orange': Colors.orange,
  'pink': Colors.pink,
};

class Space {
  late String name;
  late String color;
  late MaterialColor materialColor;
  late List<Bubble> bubbleList;

  Space({required this.name, required this.color, required this.bubbleList}) {
    materialColor = COLORS[color] ?? Colors.grey;
  }

  Space.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    color = json['color'];
    materialColor = COLORS[color] ?? Colors.grey;
    bubbleList = json['bubbleList'];
  }

  Space.fromTemplate() {
    name = '';
    color = 'grey';
    materialColor = Colors.grey;
    bubbleList = [];
  }

  Space.copy(Space other) {
    name = other.name;
    color = other.color;
    materialColor = other.materialColor;
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
