const bubbleTypeList = ['punctual', 'daily', 'weekly', 'monthly'];

class Bubble {
  late String name;
  late String color;
  late String type;

  Bubble({required this.name, required this.color, required this.type});

  Bubble.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    color = json['color'];
    type = json['type'];
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

  @override
  String toString() {
    return 'Tapis : $name / Travail : $type / color : $color';
  }
}
