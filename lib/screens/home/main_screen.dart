import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/screens/home/discussions_screen.dart';
import 'package:m3fund_flutter/screens/home/home_screen.dart';
import 'package:m3fund_flutter/screens/home/settings_sceen.dart';
import 'package:m3fund_flutter/screens/home/stats_screen.dart';
import 'package:remixicon/remixicon.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;
  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _selectedIndex;
  bool _isAuthenticated = false;

  List<Widget> _pages = [];

  @override
  void initState() {
    _selectedIndex = widget.initialIndex;
    super.initState();
    _loadIsAuthenticatedState();
  }

  Future<void> _loadIsAuthenticatedState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isAuthenticated = prefs.getBool("isAuthenticated") ?? false;
      _pages = [
        HomeScreen(isAuthenticated: _isAuthenticated),
        StatsScreen(isAuthenticated: _isAuthenticated),
        DiscussionsScreen(isAuthenticated: _isAuthenticated),
        SettingsSceen(isAuthenticated: _isAuthenticated),
      ];
    });
  }

  @override
  void activate() {
    _loadIsAuthenticatedState();
    super.activate();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(),
      child: Scaffold(
        body: IndexedStack(index: _selectedIndex, children: _pages),
        extendBody: true,
        bottomNavigationBar: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              padding: const EdgeInsets.only(bottom: 10),
              height: 95,
              width: double.infinity,
              child: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  height: 68,
                  width: 350,
                  child: Container(
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.all(10),
                    child: GNav(
                      gap: 5,
                      color: Colors.white,
                      activeColor: Colors.white,
                      tabBackgroundColor: customBlackColor,
                      curve: Curves.easeInCubic,
                      tabBorderRadius: 10,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      iconSize: 28,
                      selectedIndex: _selectedIndex,
                      onTabChange: (index) {
                        setState(() => _selectedIndex = index);
                      },
                      tabs: [
                        GButton(
                          icon: _selectedIndex == 0
                              ? RemixIcons.home_9_fill
                              : RemixIcons.home_9_line,
                          text: "Accueil",
                          textStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        GButton(
                          icon: _selectedIndex == 1
                              ? RemixIcons.line_chart_fill
                              : RemixIcons.line_chart_line,
                          text: "Statistiques",
                          textStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        GButton(
                          icon: _selectedIndex == 2
                              ? RemixIcons.question_answer_fill
                              : RemixIcons.question_answer_line,
                          text: "Discussions",
                          textStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        GButton(
                          icon: _selectedIndex == 3
                              ? RemixIcons.settings_5_fill
                              : RemixIcons.settings_5_line,
                          text: "Paramètres",
                          textStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
