import 'package:flutter/foundation.dart';

/// Shared motion signals for every bubble in a space.
///
/// Bubbles listen and react when [shakeToken] or [explodeToken] changes.
class BubbleMotionController extends ChangeNotifier {
  double _shakeIntensity = 0;
  int _shakeToken = 0;
  int _explodeToken = 0;

  double get shakeIntensity => _shakeIntensity;
  int get shakeToken => _shakeToken;
  int get explodeToken => _explodeToken;

  void shake(double intensity) {
    _shakeIntensity = intensity;
    _shakeToken++;
    notifyListeners();
  }

  void explodeAll() {
    _explodeToken++;
    notifyListeners();
  }
}
