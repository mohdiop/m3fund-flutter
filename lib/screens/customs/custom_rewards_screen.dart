import 'package:flutter/material.dart';
import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/models/responses/reward_response.dart';
import 'package:m3fund_flutter/screens/home/campaign_details_screen.dart';

class CustomRewardsScreen extends StatefulWidget {
  final List<RewardResponse> rewards;
  const CustomRewardsScreen({super.key, required this.rewards});

  @override
  State<CustomRewardsScreen> createState() => _CustomRewardsScreenState();
}

class _CustomRewardsScreenState extends State<CustomRewardsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: f4Grey),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: widget.rewards.isEmpty
          ? Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Récompenses disponibles",
                  style: const TextStyle(fontSize: 15, color: Colors.black),
                ),
                Center(child: Text("Aucune récompense pour cette campagne")),
              ],
            )
          : Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Récompenses disponibles",
                  style: const TextStyle(fontSize: 15, color: Colors.black),
                ),
                ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(5),
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 20,
                      children: widget.rewards
                          .map(
                            (reward) => Container(
                              width: 200,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    spreadRadius: 0,
                                    blurRadius: 2,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.all(10),
                              child: Column(
                                spacing: 5,
                                children: [
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset("assets/reward.png"),
                                      ),

                                      Positioned.fromRect(
                                        rect: Rect.fromLTRB(5, 5, 100, 35),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                            shape: BoxShape.rectangle,
                                            color: primaryColor,
                                          ),
                                          child: Center(
                                            child: Text(
                                              "${reward.quantity} restant${reward.quantity <= 1 ? "" : "s"}",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    reward.name,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "À partir de  ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black.withValues(
                                            alpha: 0.6,
                                          ),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        "${formatToFrAmount(reward.unlockAmount)} FCFA",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    reward.description,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
