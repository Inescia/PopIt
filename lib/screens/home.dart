import 'package:flutter/material.dart';
import 'package:popit/classes/bubble.dart';
import 'package:popit/components/bubble_modal.dart';
import 'package:popit/components/bubble_widget.dart';
import 'package:popit/providers/space_provider.dart';
import 'package:popit/screens/dashboard.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  final int initialPage;
  const Home({this.initialPage = 0, super.key});
  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  Future<void> _removeBubble(BuildContext context, int index) async {
    // setState(() => _isLoading = true);
    await Provider.of<SpaceProvider>(context, listen: false)
        .removeBubble(_currentPage - 1, index);
    setState(() {}); // => _isLoading = false);
  }

  Color getColorByIndex(SpaceProvider provider, int index) {
    return provider.getSpaceByIndex(index)!.materialColor.shade200;
  }

  bool isDashboard([int? index]) {
    return index == 0 || _currentPage == 0;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SpaceProvider>(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          title: Text(isDashboard()
              ? 'Tdb'
              : provider.spaceList[_currentPage - 1].name),
          actions: [
            IconButton(
                onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const Dashboard())),
                icon: Icon(
                  Icons.settings_rounded,
                  color: isDashboard()
                      ? Colors.grey
                      : getColorByIndex(provider, _currentPage - 1),
                  size: 30,
                ))
          ],
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
                      color: isDashboard()
                          ? Colors.grey
                          : getColorByIndex(provider, _currentPage - 1))))),
      body: Stack(children: [
        PageView.builder(
            controller: _pageController,
            itemCount: provider.spaceList.length + 1,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              if (index == 0) {
                return Container(); //Dashboard();
              } else {
                return Stack(alignment: Alignment.center, children: [
                  for (MapEntry<int, Bubble> entry in provider
                      .spaceList[index - 1].bubbleList
                      .asMap()
                      .entries)
                    BubbleWidget(
                        bubble: entry.value,
                        onPopit: () => _removeBubble(context, entry.key),
                        onTap: () => showDialog(
                            context: context,
                            barrierColor: Colors.white.withAlpha(0),
                            builder: (BuildContext context) => BubbleModal(
                                  spaceIndex: index - 1,
                                  bubble: entry.value,
                                  index: entry.key,
                                )))
                ]);
              }
            }),
        if (!isDashboard())
          Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(provider.spaceList.length, (index) {
                    return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        width: _currentPage - 1 == index ? 12 : 8,
                        height: _currentPage - 1 == index ? 12 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? getColorByIndex(provider, index)
                              : getColorByIndex(provider, index).withAlpha(150),
                          shape: BoxShape.circle,
                        ));
                  })))
      ]),
      floatingActionButton: isDashboard()
          ? null
          : FloatingActionButton(
              backgroundColor: getColorByIndex(provider, _currentPage - 1),
              child: const Icon(Icons.add_rounded, size: 40),
              onPressed: () => showDialog(
                  barrierColor: Colors.white.withAlpha(0),
                  context: context,
                  builder: (BuildContext context) =>
                      BubbleModal(spaceIndex: _currentPage, isNew: true)),
            ),
    );
  }
}
