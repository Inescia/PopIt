import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// Detects phone shakes from the user accelerometer.
///
/// Moderate shakes call [onShake] with an intensity used to jostle bubbles.
/// A hard shake calls [onStrongShake] so every bubble can pop.
class ShakeDetector {
  ShakeDetector({
    required this.onShake,
    required this.onStrongShake,
    this.shakeThreshold = 4.5,
    this.strongShakeThreshold = 14.0,
    this.shakeCooldown = const Duration(milliseconds: 120),
    this.strongShakeCooldown = const Duration(milliseconds: 1600),
  });

  final void Function(double intensity) onShake;
  final VoidCallback onStrongShake;
  final double shakeThreshold;
  final double strongShakeThreshold;
  final Duration shakeCooldown;
  final Duration strongShakeCooldown;

  StreamSubscription<UserAccelerometerEvent>? _subscription;
  DateTime? _lastShakeAt;
  DateTime? _lastStrongShakeAt;

  void start() {
    _subscription?.cancel();
    _subscription = userAccelerometerEventStream(
      samplingPeriod: SensorInterval.gameInterval,
    ).listen(_onAccelerometerEvent, onError: (_) {});
  }

  void stop() {
    _subscription?.cancel();
    _subscription = null;
  }

  void _onAccelerometerEvent(UserAccelerometerEvent event) {
    final magnitude =
        sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
    final now = DateTime.now();

    if (magnitude >= strongShakeThreshold) {
      if (_lastStrongShakeAt == null ||
          now.difference(_lastStrongShakeAt!) >= strongShakeCooldown) {
        _lastStrongShakeAt = now;
        _lastShakeAt = now;
        onStrongShake();
      }
      return;
    }

    if (magnitude >= shakeThreshold) {
      if (_lastShakeAt == null ||
          now.difference(_lastShakeAt!) >= shakeCooldown) {
        _lastShakeAt = now;
        // Map raw magnitude into a pleasant impulse range for bubble physics.
        final intensity = ((magnitude - shakeThreshold) / 2.5).clamp(1.5, 12.0);
        onShake(intensity.toDouble());
      }
    }
  }

  void dispose() => stop();
}
