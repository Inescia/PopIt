import 'package:flutter/material.dart';

/// Shared visual style for bubbles across the app (space, empty state, modal).
class BubbleStyle {
  BubbleStyle._();

  static const Alignment gradientCenter = Alignment(-0.2, -0.4);
  static const double gradientRadius = 0.9;
  static const List<double> gradientStops = [0.1, 0.6, 1.0];

  static List<Color> gradientColors(MaterialColor color) => [
        color.shade200,
        color.shade200,
        color.shade400,
      ];

  static BoxDecoration decoration(
    MaterialColor color, {
    double shadowBlur = 16,
    Offset shadowOffset = const Offset(0, 4),
    Border? border,
  }) {
    return BoxDecoration(
      shape: BoxShape.circle,
      gradient: RadialGradient(
        center: gradientCenter,
        radius: gradientRadius,
        colors: gradientColors(color),
        stops: gradientStops,
      ),
      border: border,
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          offset: shadowOffset,
          blurRadius: shadowBlur,
        ),
      ],
    );
  }

  /// Circular bubble shell used for previews and decorative ghosts.
  static Widget circle({
    required MaterialColor color,
    required double size,
    Widget? child,
    double opacity = 1,
    double shadowBlur = 16,
    Offset shadowOffset = const Offset(0, 4),
    Border? border,
  }) {
    final bubble = Container(
      width: size,
      height: size,
      decoration: decoration(
        color,
        shadowBlur: shadowBlur,
        shadowOffset: shadowOffset,
        border: border,
      ),
      alignment: Alignment.center,
      child: child,
    );

    if (opacity >= 1) return bubble;
    return Opacity(opacity: opacity, child: bubble);
  }
}
