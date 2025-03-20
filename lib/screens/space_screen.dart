import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:popit/providers/app_provider.dart';
import 'package:popit/classes/bubble.dart';
import 'package:popit/classes/particle.dart';
import 'package:popit/components/bubble_modal.dart';
import 'package:popit/components/bubble_widget.dart';

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
  late Ticker _ticker;

  Future<void> _handleExplosion(
      BuildContext context, int index, List<Particle> particles) async {
    _particlesList.addAll(particles);
    await Provider.of<AppProvider>(context, listen: false)
        .removeBubble(widget.index, index);
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
  }

  @override
  void dispose() {
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
            onDraggingToggle: (value) => widget.onDraggingToggle(value),
            onPopit: (particles) =>
                _handleExplosion(context, bubble.key, particles),
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
