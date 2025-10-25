import 'package:flutter/material.dart';
import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/screens/home/campaigns_screen.dart';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: 110,
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        leading: Padding(
          padding: EdgeInsets.all(10),
          child: Image.asset("assets/nbLogoName.png"),
        ),
        bottom: PreferredSize(
          preferredSize: Size(350, 44),
          child: ClipRRect(
            child: Container(
              padding: EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(color: Colors.white),
              alignment: AlignmentGeometry.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  SizedBox(
                    width: 295,
                    height: 44,
                    child: TextField(
                      cursorColor: customBlackColor,
                      style: TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: f4Grey,
                        hoverColor: f4Grey,
                        hint: Text(
                          "Rechercher par ici ...",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromRGBO(0, 0, 0, 0.6),
                          ),
                        ),
                        prefixIcon: Icon(RemixIcons.search_2_line, size: 24),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: SizedBox(
                      width: 44,
                      height: 44,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                          color: f4Grey,
                        ),
                        child: Icon(RemixIcons.equalizer_2_line),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
      body: CampaignsScreen(
        isAuthenticated: widget.isAuthenticated,
        userPosition: "Sotuba, Bamako, Mali",
      ),
    );
  }
}
