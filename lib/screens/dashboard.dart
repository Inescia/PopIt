// ignore_for_file: file_names, slash_for_doc_comments
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:popit/classes/space.dart';
import 'package:provider/provider.dart';
import 'package:popit/providers/space_provider.dart';
import 'package:popit/components/locale-icon.dart';
import 'package:popit/components/space_modal.dart';
import 'package:popit/components/space_card.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _Dashboard();
}

class _Dashboard extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SpaceProvider>(context);
    return Scaffold(
        appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.pageTitle),
            actions: const [LocaleIcon()],
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(3),
                child: Container(
                    margin: const EdgeInsets.only(right: 125),
                    width: double.infinity,
                    height: 3,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 2),
                              blurRadius: 6)
                        ],
                        color: Theme.of(context).primaryColor)))),
        body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.only(top: 15, bottom: 35),
                width: double.infinity,
                child: Column(children: [
                  for (MapEntry<int, Space> entry
                      in provider.spaceList.asMap().entries)
                    SpaceCard(space: entry.value, index: entry.key)
                ]))),
        floatingActionButton: provider.spaceList.length < 10
            ? FloatingActionButton(
                backgroundColor: Theme.of(context).primaryColor,
                child: const Icon(Icons.add_rounded, size: 40),
                onPressed: () => showDialog(
                    barrierColor: Colors.white.withAlpha(0),
                    context: context,
                    builder: (BuildContext context) =>
                        const SpaceModal(isNew: true)))
            : null);
  }
}
