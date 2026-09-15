import 'dart:async';
import 'dart:math';

import 'package:sensors_plus/sensors_plus.dart';

/// Detects phone shakes from the user accelerometer.
///
/// Shakes call [onShake] with an intensity used to jostle bubbles.
class ShakeDetector {
  ShakeDetector({
    required this.onShake,
    this.shakeThreshold = 5.2,
    this.shakeCooldown = const Duration(milliseconds: 90),
  });

  final void Function(double intensity) onShake;
  final double shakeThreshold;
  final Duration shakeCooldown;

  StreamSubscription<UserAccelerometerEvent>? _subscription;
  DateTime? _lastShakeAt;

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

    if (magnitude >= shakeThreshold) {
      if (_lastShakeAt == null ||
          now.difference(_lastShakeAt!) >= shakeCooldown) {
        _lastShakeAt = now;
        // 0 = just above threshold, 1 = strong shake (~threshold + 12).
        // Squared curve: light stays light, strong ramps up clearly.
        final t = ((magnitude - shakeThreshold) / 12.0).clamp(0.0, 1.0);
        final intensity = 0.7 + (t * t) * 14.5;
        onShake(intensity);
      }
    }
  }

  void dispose() => stop();
}
