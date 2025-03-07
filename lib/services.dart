import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:popit/classes/bubble.dart';
import 'package:popit/classes/space.dart';
import 'dart:async';

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
    } catch (e) {
      debugPrint('Error initHive() : $e');
      rethrow;
    }
  }

  static Space? getSpaceByIndex(int index) {
    return box.getAt(index);
  }

  static List<Bubble> getBubbleList(int spaceIndex) {
    Space space = getSpaceByIndex(spaceIndex)!;
    return space.bubbleList;
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
      await box.putAt(index, space);
    } catch (e) {
      debugPrint('Error updateSpaceByIndex() : $e');
    }
  }

  static Future<void> removeSpaceByIndex(int index) async {
    try {
      await box.deleteAt(index);
    } catch (e) {
      debugPrint('Error removeSpaceByIndex() : $e');
    }
  }

  static Future<void> addBubble(int spaceIndex, Bubble bubble) async {
    try {
      Space space = getSpaceByIndex(spaceIndex)!;
      space.bubbleList.add(bubble);
      await space.save();
    } catch (e) {
      debugPrint('Error addBubble() : $e');
    }
  }

  static Future<void> updateBubbleByIndex(
      int spaceIndex, int index, Bubble bubble) async {
    try {
      Space space = getSpaceByIndex(spaceIndex)!;
      space.bubbleList[index] = bubble;
      await space.save();
    } catch (e) {
      debugPrint('Error updateBubble() : $e');
    }
  }

  static Future<void> removeBubbleByIndex(int spaceIndex, int index) async {
    try {
      Space space = getSpaceByIndex(spaceIndex)!;
      space.bubbleList.removeAt(index);
      await space.save();
    } catch (e) {
      debugPrint('Error removeBubble() : $e');
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
