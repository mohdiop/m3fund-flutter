import 'package:flutter/material.dart';
import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/tools/utils.dart';
import 'package:remixicon/remixicon.dart';

class HomeScreen extends StatefulWidget {
  final bool isAuthenticated;
  const HomeScreen({super.key, required this.isAuthenticated});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _hasUnreadNotifications = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 110,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: EdgeInsets.all(10),
          child: Image.asset("assets/nbLogoName.png"),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              style: IconButton.styleFrom(
                backgroundColor: primaryColor,
                maximumSize: Size(40, 40),
              ),
              icon: Stack(
                children: [
                  Icon(
                    RemixIcons.notification_line,
                    size: 24,
                    color: Colors.white,
                  ),
                  if (_hasUnreadNotifications)
                    Positioned(
                      width: 7,
                      height: 7,
                      top: 3,
                      left: 16,
                      child: Container(
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              onPressed: () {
                if (!widget.isAuthenticated) {
                  showRequestConnectionDialog(context);
                }
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              if (!widget.isAuthenticated) {
                showRequestConnectionDialog(context);
              }
            },
            child: Container(
              margin: EdgeInsets.only(right: 10),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: customBlackColor, width: 3),
              ),
              child: ClipOval(
                child: Image.asset("assets/default.jpg", fit: BoxFit.cover),
              ),
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Center(child: Text("Home Screen")),
    );
  }
}
