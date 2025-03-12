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
      if (space == null || index < 0 || index >= space.bubbleList.length)
        return;

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
