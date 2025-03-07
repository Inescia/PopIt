import 'package:flutter/material.dart';
import 'package:popit/classes/bubble.dart';
import 'package:popit/classes/space.dart';
import 'package:popit/services.dart';

class SpaceProvider extends ChangeNotifier {
  List<Space> _spaceList = [];

  SpaceProvider() {
    HiveService.initHive().then((value) => loadSpaceList());
  }

  List<Space> get spaceList => _spaceList;

  Space? getSpaceByIndex(int index) {
    return _spaceList[index];
  }

  void loadSpaceList() {
    _spaceList = HiveService.spaceList;
    notifyListeners();
  }

  Future<void> addSpace(Space space) async {
    _spaceList.add(space);
    await HiveService.addSpace(space);
    notifyListeners();
  }

  Future<void> removeSpace(int index) async {
    await HiveService.removeSpaceByIndex(index);
    _spaceList.removeAt(index);
    notifyListeners();
  }

  Future<void> updateSpace(Space space, int index) async {
    _spaceList[index] = space;
    await HiveService.updateSpaceByIndex(index, space);
    notifyListeners();
  }

  Future<void> addBubble(int spaceIndex, Bubble bubble) async {
    await HiveService.addBubble(spaceIndex, bubble);
    notifyListeners();
  }

  Future<void> removeBubble(int spaceIndex, int index) async {
    await HiveService.removeBubbleByIndex(spaceIndex, index);
    notifyListeners();
  }

  Future<void> updateBubble(int spaceIndex, Bubble bubble, int index) async {
    await HiveService.updateBubbleByIndex(spaceIndex, index, bubble);
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    HiveService.closeHive();
  }
}
