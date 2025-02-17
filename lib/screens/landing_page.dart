import 'package:flutter/material.dart';
import 'package:versealyric/screens/ui_favourite.dart';

import 'ui_search_page.dart'; // rest screens


class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  int currentBottomTabIndex = 0;

  List<BottomNavigationBarItem> bottomNavBarItems = const [
    BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search",backgroundColor: Colors.grey),
    BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: "Favorites",backgroundColor: Colors.grey),
    BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "Profile",backgroundColor: Colors.grey),
  ];

  List<Widget> uiPages() {
    return <Widget>[
      const FrontPage(),
      const UiFavourite(),
      // const SearchPage(title: '1'),
      // const SearchPage(title: '2'),
      // const SearchPage(title: '3'),
      // const SearchUi(),
      // const QueueUi(),
      // const ProfileUi(),
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
            });
          },
        ),
        body: uiPages()[currentBottomTabIndex]
    );
  }
}

// import '../providers/theme_provider.dart';
// final themeProvider = Provider.of<ThemeProvider>(context); // above return scaffold
// ElevatedButton(
// onPressed: () {
// themeProvider.toggleTheme(); //
// },
// child: const Text('Toggle Theme'),
// ),
