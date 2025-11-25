import 'package:flutter/material.dart';
import 'package:m3fund_flutter/screens/settings/account_screen.dart';
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
          padding: EdgeInsets.only(
            left: (MediaQuery.of(context).size.width - 350) / 2,
            top: 10,
            right: 10,
          ),
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
            SizedBox(height: MediaQuery.of(context).size.height - 380),
            Text(
              "v1.0.0",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
