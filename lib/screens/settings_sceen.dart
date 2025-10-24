import 'package:flutter/material.dart';
import 'package:m3fund_flutter/screens/account_screen.dart';
import 'package:m3fund_flutter/screens/customs/custom_sub_menu.dart';
import 'package:m3fund_flutter/tools/utils.dart';
import 'package:remixicon/remixicon.dart';

class SettingsSceen extends StatefulWidget {
  final bool isAuthenticated;
  const SettingsSceen({super.key, required this.isAuthenticated});

  @override
  State<SettingsSceen> createState() => _SettingsSceenState();
}

class _SettingsSceenState extends State<SettingsSceen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leadingWidth: 300,
        leading: Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            "Paramètres",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Center(
        child: Column(
          spacing: 15,
          children: [
            GestureDetector(
              onTap: () {
                if (!widget.isAuthenticated) {
                  showRequestConnectionDialog(context);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AccountScreen()),
                  );
                }
              },
              child: CustomSubMenu(
                leftIcon: RemixIcons.shield_user_line,
                rightIcon: RemixIcons.arrow_right_s_line,
                menuTitle: "Compte",
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: CustomSubMenu(
                leftIcon: RemixIcons.global_line,
                rightIcon: RemixIcons.arrow_right_s_line,
                menuTitle: "Changer la langue",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
