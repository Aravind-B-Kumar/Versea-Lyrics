import 'package:flutter/material.dart';
import 'package:versealyric/screens/ui_favourite.dart';
import 'package:versealyric/screens/ui_info.dart';
import 'package:versealyric/screens/ui_search_page.dart';


class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  int currentBottomTabIndex = 0;
  final PageController _pageController = PageController();

  List<BottomNavigationBarItem> bottomNavBarItems = const [
    BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search",backgroundColor: Colors.grey),
    BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: "Favorites",backgroundColor: Colors.grey),
    BottomNavigationBarItem(icon: Icon(Icons.info_outline), label: "Info",backgroundColor: Colors.grey),
  ];

  List<Widget> uiPages() {
    return <Widget>[
      const UiSearchPage(),
      const UiFavourite(),
      const UiInfo(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Versea Lyric'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        showUnselectedLabels: false,
        currentIndex: currentBottomTabIndex,
        items: bottomNavBarItems,
        onTap: (index) {
          setState(() {
            currentBottomTabIndex = index;
            _pageController.jumpToPage(index);
          });
        },
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            currentBottomTabIndex = index;
          });
        },
        children: uiPages(),
      ),
    );
  }
}
