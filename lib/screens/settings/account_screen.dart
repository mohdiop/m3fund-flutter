import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/screens/customs/custom_sub_menu.dart';
import 'package:m3fund_flutter/screens/settings/change_email_screen.dart';
import 'package:m3fund_flutter/screens/settings/change_number_screen.dart';
import 'package:m3fund_flutter/screens/settings/change_password_screen.dart';
import 'package:remixicon/remixicon.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: AppBar(
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.white,
                toolbarHeight: 50,
                leadingWidth:
                    ((MediaQuery.of(context).size.width - 350) / 2) + 43,
                centerTitle: true,
                title: Text(
                  "Compte",
                  style: const TextStyle(fontSize: 24, color: Colors.black),
                ),
                leading: Padding(
                  padding: EdgeInsets.only(
                    left: (MediaQuery.of(context).size.width - 350) / 2,
                  ),
                  child: IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: const CircleBorder(),
                    ),
                    icon: const Icon(
                      RemixIcons.arrow_left_line,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20),
        child: Center(
          child: Column(
            spacing: 15,
            children: [
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ChangeNumberScreen()),
                ),
                child: CustomSubMenu(
                  leftIcon: RemixIcons.phone_line,
                  rightIcon: RemixIcons.arrow_right_s_line,
                  menuTitle: "Changer de numéro",
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ChangeEmailScreen()),
                ),
                child: CustomSubMenu(
                  leftIcon: RemixIcons.mail_line,
                  rightIcon: RemixIcons.arrow_right_s_line,
                  menuTitle: "Changer d'émail",
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ChangePasswordScreen()),
                ),
                child: CustomSubMenu(
                  leftIcon: RemixIcons.lock_line,
                  rightIcon: RemixIcons.arrow_right_s_line,
                  menuTitle: "Changer de mot de passe",
                ),
              ),
              CustomSubMenu(
                leftIcon: RemixIcons.user_heart_line,
                rightIcon: RemixIcons.arrow_right_s_line,
                menuTitle: "Modifier les préférences",
              ),
              CustomSubMenu(
                leftIcon: RemixIcons.delete_bin_2_line,
                rightIcon: RemixIcons.arrow_right_s_line,
                menuTitle: "Supprimer mon compte",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
