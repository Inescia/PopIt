import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:popit/components/locale_icon.dart';
import 'package:popit/components/bubble_modal.dart';
import 'package:popit/components/space_modal.dart';
import 'package:popit/providers/app_provider.dart';
import 'package:popit/screens/dashboard.dart';
import 'package:popit/screens/space_screen.dart';
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
  bool _isDragging = false;

  bool _isDashboard([int? index]) => index == 0 || _currentPage == 0;

  Color _getColorByIndex(AppProvider provider, int index) {
    return provider.getSpaceByIndex(index)!.materialColor.shade200;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            title: Text(
                _isDashboard()
                    ? AppLocalizations.of(context)!.dashboard
                    : provider.spaceList[_currentPage - 1].name,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    shadows: const [
                      BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 2),
                          blurRadius: 6)
                    ],
                    color: _isDashboard()
                        ? Theme.of(context).primaryColor
                        : _getColorByIndex(provider, _currentPage - 1))),
            actions: _isDashboard()
                ? const [LocaleIcon()]
                : [
                    IconButton(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 17),
                        onPressed: () => _pageController.animateToPage(
                              0,
                              duration: Duration(
                                  milliseconds: 300 * (_currentPage + 1)),
                              curve: Curves.easeInOut,
                            ),
                        icon: Image.asset('assets/home.png'))
                  ],
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(3),
                child: Container(
                    margin: const EdgeInsets.only(right: 125),
                    width: double.infinity,
                    height: 4,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 2),
                              blurRadius: 6)
                        ],
                        color: _isDashboard()
                            ? Theme.of(context).primaryColor
                            : _getColorByIndex(provider, _currentPage - 1))))),
        body: Stack(children: [
          Positioned.fill(
              child: Image.asset('assets/bg.jpg', fit: BoxFit.cover)),
          PageView.builder(
              pageSnapping: !_isDragging,
              controller: _pageController,
              itemCount: provider.spaceList.length + 1,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return DashBoard(
                      onCardTap: (int spaceIndex) =>
                          _pageController.animateToPage(
                            spaceIndex + 1,
                            duration:
                                Duration(milliseconds: 300 * (spaceIndex + 1)),
                            curve: Curves.easeInOut,
                          ));
                } else {
                  return SpaceScreen(
                      index: index - 1,
                      bubbleList: provider.spaceList[index - 1].bubbleList,
                      onDraggingToggle: (value) => _isDragging = value);
                }
              }),
          if (!_isDashboard())
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
                                ? _getColorByIndex(provider, index)
                                : _getColorByIndex(provider, index)
                                    .withAlpha(150),
                            shape: BoxShape.circle,
                          ));
                    })))
        ]),
        floatingActionButton: _isDashboard()
            ? provider.spaceList.length < 20
                ? FloatingActionButton(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: const Icon(Icons.add_rounded, size: 40),
                    onPressed: () => showDialog(
                        barrierColor: Colors.white.withAlpha(0),
                        context: context,
                        builder: (BuildContext context) =>
                            const SpaceModal(isNew: true)))
                : null
            : provider.spaceList[_currentPage - 1].bubbleList.length < 10
                ? FloatingActionButton(
                    backgroundColor:
                        _getColorByIndex(provider, _currentPage - 1),
                    child: const Icon(Icons.add_rounded, size: 40),
                    onPressed: () => showDialog(
                        context: context,
                        barrierColor: Colors.white.withAlpha(0),
                        barrierDismissible: false,
                        builder: (BuildContext context) => BubbleModal(
                            spaceIndex: _currentPage - 1, isNew: true)))
                : null);
  }
}
