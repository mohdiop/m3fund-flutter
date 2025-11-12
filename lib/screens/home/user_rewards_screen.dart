import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/models/responses/reward_winning_response.dart';
import 'package:m3fund_flutter/screens/home/campaign_details_screen.dart';
import 'package:remixicon/remixicon.dart';

class UserRewardsScreen extends StatefulWidget {
  final List<RewardWinningResponse> rewards;
  const UserRewardsScreen({super.key, required this.rewards});

  @override
  State<UserRewardsScreen> createState() => _UserRewardsScreenState();
}

class _UserRewardsScreenState extends State<UserRewardsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: AppBar(
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                toolbarHeight: 70,
                centerTitle: true,
                title: Text(
                  "Mes récompenses gagnées",
                  style: const TextStyle(fontSize: 18, color: Colors.black),
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

                bottom: PreferredSize(
                  preferredSize: Size(350, 44),
                  child: ClipRRect(
                    child: Container(
                      padding: EdgeInsets.only(bottom: 5, top: 10),
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
                                prefixIcon: Icon(
                                  RemixIcons.search_2_line,
                                  size: 24,
                                ),
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
              ),
            ),
          ),
        ),
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 170, bottom: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 15,
              children: [
                if (widget.rewards.isEmpty)
                  Center(
                    child: Text(
                      "Aucune récompense gagnée pour l'instant.",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black.withValues(alpha: 0.6),
                      ),
                    ),
                  )
                else
                  ...widget.rewards.map(
                    (reward) => Center(
                      child: Container(
                        width: 300,
                        height: 54,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.6),
                              offset: Offset(0, 0),
                              blurRadius: 1,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Row(
                          spacing: 10,
                          children: [
                            Image.asset("assets/reward.png"),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  reward.reward.name,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: "Gagné le ",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black.withValues(
                                        alpha: 0.6,
                                      ),
                                    ),
                                    children: [
                                      TextSpan(
                                        text: formatToDateAndTimeFr(
                                          reward.gainedAt,
                                        ),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
