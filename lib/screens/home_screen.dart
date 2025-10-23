import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:m3fund_flutter/constants.dart';
import 'package:remixicon/remixicon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(),
      child: Scaffold(
        body: Center(
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (int i = 0; i < 100; i++)
                    Text(
                      "Exejhefkpjezpfjpkzjmfjemjfmkajefjaemljfmlaejmfjealjfmljeaemple",
                    ),
                ],
              ),
            ),
          ),
        ),
        extendBody: true,
        bottomNavigationBar: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              padding: const EdgeInsets.only(bottom: 10),
              height: 90,
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
                      selectedIndex: _selectIndex,
                      onTabChange: (index) {
                        setState(() => _selectIndex = index);
                      },
                      tabs: [
                        GButton(
                          icon: _selectIndex == 0
                              ? RemixIcons.home_9_fill
                              : RemixIcons.home_9_line,
                          text: "Accueil",
                          textStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        GButton(
                          icon: _selectIndex == 1
                              ? RemixIcons.line_chart_fill
                              : RemixIcons.line_chart_line,
                          text: "Statistiques",
                          textStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        GButton(
                          icon: _selectIndex == 2
                              ? RemixIcons.question_answer_fill
                              : RemixIcons.question_answer_line,
                          text: "Discussions",
                          textStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        GButton(
                          icon: _selectIndex == 3
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
