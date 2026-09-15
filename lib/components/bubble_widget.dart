import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:popit/classes/bubble.dart';
import 'package:popit/classes/particle.dart';
import 'package:popit/components/bubble_style.dart';
import 'package:popit/controllers/bubble_motion_controller.dart';

class BubbleWidget extends StatefulWidget {
  final Bubble bubble;
  final VoidCallback onTap;
  final Function onDraggingToggle;
  final Function(List<Particle>) onPopit;
  final BubbleMotionController? motionController;

  const BubbleWidget({
    required this.onTap,
    required this.onDraggingToggle,
    required this.onPopit,
    required this.bubble,
    this.motionController,
    super.key,
  });

  @override
  State<BubbleWidget> createState() => _BubbleWidgetState();
}

class _BubbleWidgetState extends State<BubbleWidget>
    with TickerProviderStateMixin {
  static const double _bubbleSize = 120;
  static const double _maxThrowSpeed = 40;
  static const double _pixelsPerSecondToFrame = 1 / 60;
  /// How quickly excess speed (after a shake/throw) eases back to cruise speed.
  static const double _settleFriction = 0.982;

  late Ticker _ticker;
  late Offset _position;
  late Offset _velocity;
  /// Gentle continuous cruise speed for this bubble (never settles to 0).
  late double _baseSpeed;

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isExploding = false;
  bool _isDragging = false;

  late DateTime _pressStartTime;
  int _lastShakeToken = 0;

  Offset _velocityWithSpeed(Offset direction, double speed) {
    final distance = direction.distance;
    if (distance < 1e-6) {
      final angle = Random().nextDouble() * pi * 2;
      return Offset(cos(angle) * speed, sin(angle) * speed);
    }
    return direction * (speed / distance);
  }

  void _settleTowardBaseSpeed() {
    final speed = _velocity.distance;
    if (speed > _baseSpeed) {
      final excess = speed - _baseSpeed;
      _velocity =
          _velocityWithSpeed(_velocity, _baseSpeed + excess * _settleFriction);
    } else {
      // Keep cruising: restore base speed, preserve current direction.
      _velocity = _velocityWithSpeed(_velocity, _baseSpeed);
    }
  }

  List<Particle> _generateParticles() {
    final Random random = Random();
    final List<Particle> particles = [];
    final double radius = _bubbleSize / 3;

    for (int i = 0; i < 15; i++) {
      final double angle = random.nextDouble() * pi * 2;
      final double speed = random.nextDouble() * 3 + 2;
      final Offset initialPosition = Offset(
        _position.dx + cos(angle) * radius,
        _position.dy + sin(angle) * radius,
      );
      particles.add(Particle(
        position: initialPosition,
        velocity: Offset(cos(angle) * speed, sin(angle) * speed),
        color: widget.bubble.materialColor.shade200,
        size: random.nextDouble() * 10 + 5,
        lifetime: random.nextDouble() * 0.8 + 5,
      ));
    }
    return particles;
  }

  void _onLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    final pressTime = DateTime.now().difference(_pressStartTime).inMilliseconds;
    const totalPressTime = 600;
    final animationProgress = pressTime / totalPressTime;
    _controller.value = animationProgress;
  }

  void _applyImpulse(double intensity) {
    if (_isExploding || _isDragging) return;
    final random = Random();
    final angle = random.nextDouble() * pi * 2;
    // Keep force proportional: light intensity ≈ nudge, high ≈ burst.
    final force = intensity * (0.55 + random.nextDouble() * 0.35);
    _velocity = _clampVelocity(
        _velocity + Offset(cos(angle) * force, sin(angle) * force));
  }

  void _triggerExplode() {
    if (_isExploding || _controller.isAnimating) return;
    _controller.forward();
  }

  void _onMotionChanged() {
    final controller = widget.motionController;
    if (controller == null) return;
    if (controller.shakeToken != _lastShakeToken) {
      _lastShakeToken = controller.shakeToken;
      _applyImpulse(controller.shakeIntensity);
    }
  }

  Offset _clampVelocity(Offset velocity) {
    final speed = velocity.distance;
    if (speed <= _maxThrowSpeed) return velocity;
    return velocity * (_maxThrowSpeed / speed);
  }

  void _updatePosition(Duration elapsed) {
    if (_isExploding || _isDragging) return;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    _position += _velocity;

    // Elastic wall bounce: reverse the axis, keep the other component.
    if (_position.dx <= 0 || _position.dx + _bubbleSize >= screenWidth) {
      _velocity = Offset(-_velocity.dx, _velocity.dy);
      _position = Offset(
        _position.dx.clamp(0, screenWidth - _bubbleSize),
        _position.dy,
      );
    }
    if (_position.dy <= 0 || _position.dy + _bubbleSize >= screenHeight) {
      _velocity = Offset(_velocity.dx, -_velocity.dy);
      _position = Offset(
        _position.dx,
        _position.dy.clamp(0, screenHeight - _bubbleSize),
      );
    }

    // After a shake/throw, ease back to this bubble's cruise speed — never stop.
    _settleTowardBaseSpeed();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    final Random random = Random();
    _position = Offset(random.nextDouble() * 300, random.nextDouble() * 600);
    _baseSpeed = 0.8 + random.nextDouble() * 1.6;
    final angle = random.nextDouble() * pi * 2;
    _velocity = Offset(cos(angle) * _baseSpeed, sin(angle) * _baseSpeed);
    _ticker = createTicker(_updatePosition);
    _ticker.start();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.addStatusListener((status) {
      _isExploding = status.isAnimating;
      if (status.isCompleted) widget.onPopit(_generateParticles());
    });

    final motionController = widget.motionController;
    if (motionController != null) {
      _lastShakeToken = motionController.shakeToken;
      motionController.addListener(_onMotionChanged);
    }
  }

  @override
  void didUpdateWidget(covariant BubbleWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.motionController != widget.motionController) {
      oldWidget.motionController?.removeListener(_onMotionChanged);
      final motionController = widget.motionController;
      if (motionController != null) {
        _lastShakeToken = motionController.shakeToken;
        motionController.addListener(_onMotionChanged);
      }
    }
  }

  @override
  void dispose() {
    widget.motionController?.removeListener(_onMotionChanged);
    _ticker.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 50),
      curve: Curves.easeInOut,
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
        onTap: widget.onTap,
        onDoubleTap: _triggerExplode,
        onLongPressStart: (details) {
          _pressStartTime = DateTime.now();
          _controller.forward();
        },
        onLongPressEnd: (details) => _controller.reverse(),
        onLongPressMoveUpdate: _onLongPressMoveUpdate,
        onPanStart: (details) {
          _isDragging = true;
          _velocity = Offset.zero;
          widget.onDraggingToggle(true);
        },
        onPanUpdate: (details) {
          _position += details.delta;
          setState(() {});
        },
        onPanEnd: (details) {
          _isDragging = false;
          widget.onDraggingToggle(false);
          final throwVelocity = details.velocity.pixelsPerSecond *
              _pixelsPerSecondToFrame *
              1.1;
          final clamped = _clampVelocity(throwVelocity);
          // Too soft a throw: resume cruising in the same direction.
          _velocity = clamped.distance < _baseSpeed
              ? _velocityWithSpeed(
                  clamped.distance > 0 ? clamped : _velocity, _baseSpeed)
              : clamped;
        },
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _isExploding ? _scaleAnimation.value : 1.0,
              child: Container(
                width: _bubbleSize,
                height: _bubbleSize,
                decoration: BubbleStyle.decoration(widget.bubble.materialColor),
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    widget.bubble.name,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
