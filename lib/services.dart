import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:popit/classes/bubble.dart';
import 'package:popit/classes/space.dart';
import 'dart:async';

Future<String> _pickImage() async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  return image!.path;
}

Future<List<String>> recognizeTextFromImage() async {
  String imagePath = await _pickImage();
  final InputImage inputImage = InputImage.fromFilePath(imagePath);
  final TextRecognizer textRecognizer =
      TextRecognizer(script: TextRecognitionScript.latin);
  final List<String> textList = [];

  try {
    final recognizedText = await textRecognizer.processImage(inputImage);
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        textList.add(
            line.text.length >= 35 ? line.text.substring(0, 35) : line.text);
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error recognizing text: $e');
    }
  }
  textRecognizer.close();
  return textList.sublist(0, 10);
}

class HiveService {
  static late Box<Space> box;

  static List<Space> get spaceList => box.values.toList();

  static Future<void> initHive() async {
    try {
      final appDocumentDir = await getApplicationDocumentsDirectory();
      Hive.init(appDocumentDir.path);
      if (!Hive.isAdapterRegistered(SpaceAdapter().typeId)) {
        Hive.registerAdapter(SpaceAdapter());
      }
      if (!Hive.isAdapterRegistered(BubbleAdapter().typeId)) {
        Hive.registerAdapter(BubbleAdapter());
      }
      box = await Hive.openBox<Space>('spaces');

      if (box.isEmpty) {
        await addSpace(Space(name: '🫧 Tutorial', color: 'blue', bubbleList: [
          Bubble(
              name: 'Click on the plus to add a bubble',
              color: 'red',
              type: 'punctual'),
          Bubble(
              name: 'Or a double-click to pop the bubble',
              color: 'teal',
              type: 'punctual'),
          Bubble(
              name: 'Long press to pop the bubble',
              color: 'salmon',
              type: 'punctual'),
          Bubble(
              name: 'Text recognizer on the camera icon',
              color: 'purple',
              type: 'punctual'),
        ]));
      }
    } catch (e) {
      debugPrint('Error initHive() : $e');
      rethrow;
    }
  }

  static Space? getSpaceByIndex(int index) {
    if (index < 0 || index >= box.length) return null;
    return box.getAt(index);
  }

  static List<Bubble> getBubbleList(int spaceIndex) {
    Space? space = getSpaceByIndex(spaceIndex);
    return space?.bubbleList ?? [];
  }

  static Future<void> addSpace(Space space) async {
    try {
      await box.add(space);
    } catch (e) {
      debugPrint('Error addSpace() : $e');
    }
  }

  static Future<void> updateSpaceByIndex(int index, Space space) async {
    try {
      if (getSpaceByIndex(index) != null) {
        await box.putAt(index, space);
      }
    } catch (e) {
      debugPrint('Error updateSpaceByIndex() : $e');
    }
  }

  static Future<void> removeSpaceByIndex(int index) async {
    try {
      if (getSpaceByIndex(index) != null) {
        await box.deleteAt(index);
      }
    } catch (e) {
      debugPrint('Error removeSpaceByIndex() : $e');
    }
  }

  static Future<void> setSpaceList(List<Space> spaceList) async {
    try {
      await box.clear();
      await box.addAll(spaceList);
    } catch (e) {
      debugPrint('Error setSpaceList() : $e');
    }
  }

  static Future<void> addBubble(int spaceIndex, Bubble bubble) async {
    try {
      Space? space = getSpaceByIndex(spaceIndex);
      if (space == null) return;

      List<Bubble> updatedBubbles = List.from(space.bubbleList)..add(bubble);
      space.bubbleList = updatedBubbles;
      await space.save();
    } catch (e) {
      debugPrint('Error addBubble() : $e');
    }
  }

  static Future<void> updateBubbleByIndex(
      int spaceIndex, int index, Bubble bubble) async {
    try {
      Space? space = getSpaceByIndex(spaceIndex);
      if (space == null || index < 0 || index >= space.bubbleList.length) {
        return;
      }

      List<Bubble> updatedBubbles = List.from(space.bubbleList);
      updatedBubbles[index] = bubble;
      space.bubbleList = updatedBubbles;
      await space.save();
    } catch (e) {
      debugPrint('Error updateBubbleByIndex() : $e');
    }
  }

  static Future<void> removeBubbleByIndex(int spaceIndex, int index) async {
    try {
      Space? space = getSpaceByIndex(spaceIndex);
      if (space == null || index < 0 || index >= space.bubbleList.length) {
        return;
      }

      List<Bubble> updatedBubbles = List.from(space.bubbleList)
        ..removeAt(index);
      space.bubbleList = updatedBubbles;
      await space.save();
    } catch (e) {
      debugPrint('Error removeBubbleByIndex() : $e');
    }
  }

  static Future<void> closeHive() async {
    try {
      await box.close();
    } catch (e) {
      debugPrint('Error closeHive() : $e');
    }
  }
}
