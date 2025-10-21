import 'package:flutter/material.dart';
import 'package:m3fund_flutter/constants.dart';
import 'package:remixicon/remixicon.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPageIndex = 0;
  bool get isFirstPage => _currentPageIndex == 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        leadingWidth: 110,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 100,
              height: 38,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: isFirstPage ? primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: isFirstPage
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start,
                    spacing: 10,
                    children: [
                      if (_currentPageIndex == 0) ...[
                        Icon(
                          RemixIcons.global_line,
                          color: Colors.white,
                          size: 20,
                        ),
                        const Text(
                          "fr",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          RemixIcons.arrow_down_s_line,
                          color: Colors.white,
                          size: 20,
                        ),
                      ] else ...[
                        // Return to last page button
                        IconButton(
                          onPressed: () {
                            if (_currentPageIndex == 2) {
                              _controller.animateToPage(
                                1,
                                duration: Duration(seconds: 1),
                                curve: Curves.easeInOut,
                              );
                            } else if (_currentPageIndex == 1) {
                              _controller.animateToPage(
                                0,
                                duration: Duration(seconds: 1),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          style: IconButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: const CircleBorder(),
                          ),
                          icon: Icon(
                            RemixIcons.arrow_left_line,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        actions: [
          // Skip Icon Button
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              style: IconButton.styleFrom(
                backgroundColor: primaryColor,
                shape: const CircleBorder(),
              ),
              onPressed: () {
                _controller.animateToPage(
                  3,
                  duration: Duration(seconds: 1),
                  curve: Curves.easeInOut,
                );
              },
              icon: Icon(
                RemixIcons.skip_right_line,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(bottom: 120),
        child: PageView(
          controller: _controller,
          onPageChanged: (index) {
            setState(() {
              _currentPageIndex = index;
            });
          },
          children: [
            Container(
              decoration: BoxDecoration(color: primaryColor),
              child: const Center(
                child: Text("First", style: TextStyle(color: Colors.white)),
              ),
            ),
            Container(
              decoration: BoxDecoration(color: secondaryColor),
              child: Text("Second"),
            ),
            Container(
              decoration: BoxDecoration(color: customBlackColor),
              child: Text("Third"),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(),
        height: 120,
        child: Column(
          children: [
            Column(
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: WormEffect(
                    activeDotColor: secondaryColor,
                    dotColor: Colors.grey.shade300,
                    dotHeight: 10,
                    dotWidth: 30,
                    spacing: 15,
                  ),
                  onDotClicked: (index) {
                    _controller.animateToPage(
                      index,
                      duration: Duration(seconds: 1),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
