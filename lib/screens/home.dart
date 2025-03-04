import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Tableau de bord'),
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(3),
                child: Container(
                    margin: const EdgeInsets.only(right: 125),
                    width: double.infinity,
                    height: 3,
                    color: Theme.of(context).primaryColor))),
        body: Container(
          child: Icon(Icons.settings_rounded),
        ));
  }
}
