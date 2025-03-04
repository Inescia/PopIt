// ignore_for_file: file_names, slash_for_doc_comments
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:popit/components/space_modal.dart';
import '../classes/space.dart';
import '../components/space-card.dart';
import '../theme.dart';
import 'home.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _Dashboard();
}

class _Dashboard extends State<Dashboard> {
  final List<Space> _spacesList = [
    Space(name: 'Travail', color: 'blue', bubbleList: []),
    Space(name: 'Loisir', color: 'red', bubbleList: []),
    Space(name: 'Sport', color: 'orange', bubbleList: []),
    Space(name: 'Animaux 🐶', color: 'pink', bubbleList: [])
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.pageTitle),
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(3),
                child: Container(
                    margin: const EdgeInsets.only(right: 125),
                    width: double.infinity,
                    height: 3,
                    color: Theme.of(context).primaryColor))),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Column(children: [
                for (Space space in _spacesList) SpaceCard(space),
                IconButton(
                  onPressed: () => showDialog(
                      barrierColor: Colors.white.withAlpha(0),
                      context: context,
                      builder: (BuildContext context) =>
                          const SpaceModal(isNew: true)),
                  icon: const Icon(Icons.add_circle_rounded),
                  color: Theme.of(context).primaryColor,
                  iconSize: 50,
                )
              ])),
        ));
  }
}
