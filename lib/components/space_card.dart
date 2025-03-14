import 'package:flutter/material.dart';
import 'package:popit/classes/space.dart';
import 'package:popit/components/space_modal.dart';

class SpaceCard extends StatelessWidget {
  final Space space;
  final int index;
  final VoidCallback onTap;
  const SpaceCard(
      {required this.space,
      required this.onTap,
      required this.index,
      super.key});

  TextStyle get _textStyle => TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              offset: Offset(2, 2),
              blurRadius: 8.0,
              color: Colors.black12,
            )
          ]);

  void _showSpaceModal(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.white.withAlpha(0),
      context: context,
      builder: (BuildContext context) => SpaceModal(space: space, index: index),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (child, animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.only(left: 15),
              width: double.infinity,
              height: 65,
              decoration: BoxDecoration(
                // boxShadow: [_boxShadow],
                color: space.materialColor.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(children: [
                Text(
                    '${space.name} - ${space.bubbleList.isEmpty ? '' : space.bubbleList.length.toString()}',
                    style: _textStyle),
                Icon(
                    space.bubbleList.isEmpty
                        ? Icons.emoji_events_rounded
                        : Icons.bubble_chart,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 8.0,
                          color: Colors.black12)
                    ]),
                Expanded(child: Container()),
                IconButton(
                    onPressed: () => _showSpaceModal(context),
                    color: Colors.white,
                    icon: const Icon(Icons.more_vert, shadows: [
                      Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 8.0,
                          color: Colors.black12)
                    ]),
                    iconSize: 25)
              ]))),
    );
  }
}
