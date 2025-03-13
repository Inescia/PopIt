import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:popit/providers/app_provider.dart';
import 'package:popit/components/space_card.dart';

class DashBoard extends StatelessWidget {
  final Function onCardTap;
  const DashBoard({required this.onCardTap, super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    return ReorderableListView(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 15,
            bottom: 120,
            left: 15,
            right: 15),
        proxyDecorator: (child, index, animation) => Material(
            elevation: 10,
            color: Colors.transparent,
            shadowColor: Colors.grey,
            borderRadius: BorderRadius.circular(20),
            child: child),
        onReorder: (oldIndex, newIndex) {
          if (oldIndex < newIndex) newIndex -= 1;
          provider.reorderSpaceList(oldIndex, newIndex);
        },
        children: [
          for (var entry in provider.spaceList.asMap().entries)
            SpaceCard(
                key: ValueKey(entry.key),
                space: entry.value,
                index: entry.key,
                onTap: () => onCardTap(entry.key))
        ]);
  }
}
