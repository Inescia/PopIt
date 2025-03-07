import 'package:flutter/material.dart';
import 'package:popit/classes/space.dart';
import 'package:popit/screens/home.dart';
import 'package:popit/components/space_modal.dart';

class SpaceCard extends StatelessWidget {
  final Space space;
  final int index;
  const SpaceCard({required this.space, required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (child, animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              padding: const EdgeInsets.only(left: 15),
              width: double.infinity,
              height: 65,
              decoration: BoxDecoration(
                color: space.materialColor.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(children: [
                Text('${space.name} - ${space.bubbleList.length.toString()}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            offset: Offset(2, 2),
                            blurRadius: 8.0,
                            color: Colors.black12,
                          )
                        ])),
                const Icon(Icons.bubble_chart, color: Colors.white, shadows: [
                  Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 8.0,
                      color: Colors.black12)
                ]),
                Expanded(child: Container()),
                IconButton(
                    onPressed: () => showDialog(
                        barrierColor: Colors.white.withAlpha(0),
                        context: context,
                        builder: (BuildContext context) =>
                            SpaceModal(space: space, index: index)),
                    color: Colors.white,
                    icon: const Icon(Icons.more_vert, shadows: [
                      Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 8.0,
                          color: Colors.black12)
                    ]),
                    iconSize: 25)
              ]))),
      onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Home(initialPage: index + 1))),
    );
  }
}
