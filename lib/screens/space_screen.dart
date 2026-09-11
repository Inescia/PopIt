import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:popit/providers/app_provider.dart';
import 'package:popit/classes/bubble.dart';
import 'package:popit/classes/particle.dart';
import 'package:popit/components/bubble_modal.dart';
import 'package:popit/components/bubble_widget.dart';
import 'package:popit/controllers/bubble_motion_controller.dart';
import 'package:popit/utils/shake_detector.dart';

class SpaceScreen extends StatefulWidget {
  final int index;
  final List<Bubble> bubbleList;
  final Function onDraggingToggle;
  const SpaceScreen(
      {required this.index,
      required this.bubbleList,
      super.key,
      required this.onDraggingToggle});

  @override
  State<SpaceScreen> createState() => _SpaceScreen();
}

class _SpaceScreen extends State<SpaceScreen> with TickerProviderStateMixin {
  final List<Particle> _particlesList = [];
  final BubbleMotionController _motionController = BubbleMotionController();
  late Ticker _ticker;
  late ShakeDetector _shakeDetector;
  final Set<Bubble> _pendingRemovals = {};

  Future<void> _handleExplosion(
      BuildContext context, Bubble bubble, List<Particle> particles) async {
    _particlesList.addAll(particles);
    if (!_pendingRemovals.add(bubble)) return;

    final provider = Provider.of<AppProvider>(context, listen: false);
    await provider.removeBubbleObject(widget.index, bubble);
    _pendingRemovals.remove(bubble);
  }

  void _updateParticles(Duration elapsed) {
    for (var particle in _particlesList) {
      particle.update();
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_updateParticles);
    _ticker.start();
    _shakeDetector = ShakeDetector(
      onShake: (intensity) => _motionController.shake(intensity),
      onStrongShake: () => _motionController.explodeAll(),
    );
    _shakeDetector.start();
  }

  @override
  void dispose() {
    _shakeDetector.dispose();
    _motionController.dispose();
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      for (MapEntry<int, Bubble> bubble in widget.bubbleList.asMap().entries)
        BubbleWidget(
            key: ValueKey(bubble.value),
            bubble: bubble.value,
            motionController: _motionController,
            onDraggingToggle: (value) => widget.onDraggingToggle(value),
            onPopit: (particles) =>
                _handleExplosion(context, bubble.value, particles),
            onTap: () => showDialog(
                context: context,
                barrierDismissible: false,
                barrierColor: Colors.white.withAlpha(0),
                builder: (BuildContext context) => BubbleModal(
                      spaceIndex: widget.index,
                      bubble: bubble.value,
                      index: bubble.key,
                    ))),
      for (Particle particle in _particlesList)
        Positioned(
            left: particle.position.dx,
            top: particle.position.dy,
            child: Container(
                width: particle.size,
                height: particle.size,
                decoration: BoxDecoration(
                    color: particle.color, shape: BoxShape.circle)))
    ]);
  }
}
