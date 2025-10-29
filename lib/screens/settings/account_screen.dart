import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/screens/customs/custom_sub_menu.dart';
import 'package:remixicon/remixicon.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  surfaceTintColor: Colors.transparent,
                  toolbarHeight: 50,
                  leadingWidth: 50,
                  centerTitle: true,
                  title: Text(
                    "Compte",
                    style: const TextStyle(fontSize: 24, color: Colors.black),
                  ),

                  leading: Padding(
                    padding: const EdgeInsets.only(left: 10),
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
                CustomSubMenu(
                  leftIcon: RemixIcons.phone_line,
                  rightIcon: RemixIcons.arrow_right_s_line,
                  menuTitle: "Changer de numéro",
                ),
                CustomSubMenu(
                  leftIcon: RemixIcons.mail_line,
                  rightIcon: RemixIcons.arrow_right_s_line,
                  menuTitle: "Changer d'émail",
                ),
                CustomSubMenu(
                  leftIcon: RemixIcons.lock_line,
                  rightIcon: RemixIcons.arrow_right_s_line,
                  menuTitle: "Changer de mot de passe",
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
      ),
    );
  }
}
