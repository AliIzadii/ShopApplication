import "package:flutter/material.dart";
import 'package:bottom_bar/bottom_bar.dart';
import 'package:shop/routes/profile.dart';
import 'package:shop/routes/store.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  int _currentPage = 0;
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          storePage(),
          profilePage(),
        ],
        onPageChanged: (index) {
          setState(() => _currentPage = index);
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 50, right: 50),
        child: BottomBar(
          selectedIndex: _currentPage,
          onTap: (int index) {
            _pageController.jumpToPage(index);
            setState(() => _currentPage = index);
          },
          items: <BottomBarItem>[
            BottomBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
              activeColor: Colors.blue,
            ),
            BottomBarItem(
              icon: Icon(Icons.person),
              title: Text('Profile'),
              activeColor: Colors.greenAccent.shade700,
            ),
          ],
        ),
      ),
    );
  }
}
