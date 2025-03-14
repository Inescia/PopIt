import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:popit/classes/bubble.dart';
import 'package:popit/classes/particle.dart';

class BubbleWidget extends StatefulWidget {
  final Bubble bubble;
  final VoidCallback onTap;
  final Function onDraggingToggle;
  final Function(List<Particle>) onPopit;

  const BubbleWidget(
      {required this.onTap,
      required this.onDraggingToggle,
      required this.onPopit,
      required this.bubble,
      super.key});

  @override
  State<BubbleWidget> createState() => _BubbleWidgetState();
}

class _BubbleWidgetState extends State<BubbleWidget>
    with TickerProviderStateMixin {
  late Ticker _ticker;
  late Offset _position;
  late Offset _velocity;
  final double _bubbleSize = 120;

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isExploding = false;

  late DateTime _pressStartTime;

  List<Particle> _generateParticles() {
    final Random random = Random();
    List<Particle> particles = [];

    double radius = _bubbleSize / 3;

    for (int i = 0; i < 15; i++) {
      double angle = random.nextDouble() * pi * 2;
      double speed = random.nextDouble() * 3 + 2;

      Offset initialPosition = Offset(_position.dx + cos(angle) * radius,
          _position.dy + sin(angle) * radius);

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
    final animationProgress = (pressTime / totalPressTime);
    _controller.value = animationProgress;
  }

  void _updatePosition(Duration elapsed) {
    if (_isExploding) return;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    _position += _velocity;

    if (_position.dx <= 0 || _position.dx + _bubbleSize >= screenWidth) {
      _velocity = Offset(-_velocity.dx * 0.9, _velocity.dy);
      _position = Offset(
          _position.dx.clamp(0, screenWidth - _bubbleSize), _position.dy);
    }
    if (_position.dy <= 0 || _position.dy + _bubbleSize >= screenHeight) {
      _velocity = Offset(_velocity.dx, -_velocity.dy * 0.9);
      _position = Offset(
          _position.dx, _position.dy.clamp(0, screenHeight - _bubbleSize));
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    final Random random = Random();
    _position = Offset(random.nextDouble() * 300, random.nextDouble() * 600);
    _velocity =
        Offset((random.nextDouble() * 4) - 2, (random.nextDouble() * 4) - 2);
    _ticker = createTicker(_updatePosition);
    _ticker.start();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.addStatusListener((status) {
      _isExploding = status.isAnimating;
      if (status.isCompleted) widget.onPopit(_generateParticles());
    });
  }

  @override
  void dispose() {
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
            onDoubleTap: () => _controller.forward(),
            onLongPressStart: (details) {
              _pressStartTime = DateTime.now();
              _controller.forward();
            },
            onLongPressEnd: (details) => _controller.reverse(),
            onLongPressMoveUpdate: _onLongPressMoveUpdate,
            onPanStart: (details) => widget.onDraggingToggle(true),
            onPanEnd: (details) => widget.onDraggingToggle(false),
            onPanUpdate: (details) {
              _position += details.delta;
              _velocity = details.delta * 0.5;
            },
            child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                      scale: _isExploding ? _scaleAnimation.value : 1.0,
                      child: Container(
                          width: _bubbleSize,
                          height: _bubbleSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              center: const Alignment(-0.2, -0.4),
                              radius: 0.9,
                              colors: [
                                widget.bubble.materialColor.shade200,
                                widget.bubble.materialColor.shade200,
                                widget.bubble.materialColor.shade400,
                              ],
                              stops: const [0.1, 0.6, 1.0],
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 4),
                                blurRadius: 16,
                              )
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                widget.bubble.name,
                                textAlign: TextAlign.center,
                                softWrap: true,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ))));
                })));
  }
}
