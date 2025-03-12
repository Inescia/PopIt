import 'package:flutter/material.dart';
import 'package:popit/classes/bubble.dart';
import 'package:popit/classes/space.dart';
import 'package:popit/services.dart';

class AppProvider extends ChangeNotifier {
  List<Space> _spaceList = [];
  final Map<String, bool> _loaders = {
    'add': false,
    'remove': false,
    'update': false
  };

  List<Space> get spaceList => _spaceList;

  AppProvider() {
    _init();
  }

  Future<void> _init() async {
    await HiveService.initHive();
    loadSpaceList();
  }

  bool isLoading(String action) => _loaders[action] ?? false;

  void setLoading(String action, bool loading) {
    _loaders[action] = loading;
    notifyListeners();
  }

  void reorderSpaceList(int oldIndex, int newIndex) {
    if (oldIndex < 0 || newIndex < 0 || oldIndex == newIndex) return;
    final Space movedItem = spaceList.removeAt(oldIndex);
    spaceList.insert(newIndex, movedItem);

    notifyListeners();
  }

  Space? getSpaceByIndex(int index) {
    return _spaceList[index];
  }

  void loadSpaceList() {
    _spaceList = HiveService.spaceList;
    notifyListeners();
  }

  Future<void> addSpace(Space space) async {
    setLoading('add', true);
    await HiveService.addSpace(space);
    _spaceList.add(space);
    setLoading('add', false);
  }

  Future<void> removeSpace(int index) async {
    setLoading('remove', true);
    await HiveService.removeSpaceByIndex(index);
    _spaceList.removeAt(index);
    setLoading('remove', false);
  }

  Future<void> updateSpace(Space space, int index) async {
    setLoading('update', true);
    await HiveService.updateSpaceByIndex(index, space);
    _spaceList[index] = space;
    setLoading('update', false);
  }

  Future<void> addBubble(int spaceIndex, Bubble bubble) async {
    setLoading('add', true);
    await HiveService.addBubble(spaceIndex, bubble);
    setLoading('add', false);
  }

  Future<void> removeBubble(int spaceIndex, int index) async {
    setLoading('remove', true);
    await HiveService.removeBubbleByIndex(spaceIndex, index);
    setLoading('remove', false);
  }

  Future<void> updateBubble(int spaceIndex, Bubble bubble, int index) async {
    setLoading('update', true);
    await HiveService.updateBubbleByIndex(spaceIndex, index, bubble);
    setLoading('update', false);
  }

  @override
  void dispose() {
    super.dispose();
    HiveService.closeHive();
  }
}
