import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/models/responses/gift_response.dart';
import 'package:m3fund_flutter/screens/home/campaign_details_screen.dart';
import 'package:m3fund_flutter/screens/home/main_screen.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final GiftResponse giftResponse;
  const PaymentSuccessScreen({super.key, required this.giftResponse});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  final ScrollController _firstScrollController = ScrollController();
  final ScrollController _secondScrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: Container(
          alignment: Alignment.topCenter,
          child: Stack(
            children: [
              ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  controller: _firstScrollController,
                  child: Column(
                    spacing: 20,
                    children: [
                      SizedBox(height: 10),
                      Image.asset("assets/successPayment.png", width: 300),
                      Container(
                        width: 350,
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
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 10,
                            children: [
                              Text(
                                "Détails sur le paiement",
                                style: TextStyle(fontSize: 16),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  spacing: 15,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "ID Transcation",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black.withValues(
                                              alpha: 0.6,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 10,
                                            ),
                                            child: Text(
                                              widget
                                                  .giftResponse
                                                  .payment
                                                  .transactionId,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Méthode de paiement",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black.withValues(
                                              alpha: 0.6,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          widget.giftResponse.payment.type.name
                                              .toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Date",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black.withValues(
                                              alpha: 0.6,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          formatToDateAndTimeFr(
                                            widget.giftResponse.payment.madeAt,
                                          ),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Montant",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black.withValues(
                                              alpha: 0.6,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "${formatToFrAmount(widget.giftResponse.payment.amount)} FCFA",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Frais",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black.withValues(
                                              alpha: 0.6,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "0 FCFA",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Total",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black.withValues(
                                              alpha: 0.6,
                                            ),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '${formatToFrAmount(widget.giftResponse.payment.amount)} FCFA',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (widget.giftResponse.gainedRewards.isNotEmpty)
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: f4Grey,
                            shape: BoxShape.rectangle,
                          ),
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left:
                                      (MediaQuery.of(context).size.width -
                                          350) /
                                      2,
                                ),
                                child: Text(
                                  "Récompenses gagnées",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              ScrollConfiguration(
                                behavior: ScrollConfiguration.of(
                                  context,
                                ).copyWith(scrollbars: false),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        (MediaQuery.of(context).size.width -
                                            350) /
                                        2,
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    controller: _secondScrollController,
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      spacing: 20,
                                      children: widget
                                          .giftResponse
                                          .gainedRewards
                                          .map(
                                            (gainedReward) => Container(
                                              height: 150,
                                              width: 160,
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withValues(alpha: 0.2),
                                                    spreadRadius: 0,
                                                    blurRadius: 5,
                                                  ),
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Column(
                                                spacing: 10,
                                                children: [
                                                  Image.asset(
                                                    "assets/reward.png",
                                                    width: 62,
                                                  ),
                                                  Text(
                                                    gainedReward.reward.name,
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Text(
                                                    '${formatToFrAmount(gainedReward.reward.unlockAmount)} FCFA et plus',
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
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
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                    child: Container(
                      color: Colors.white.withValues(alpha: 0.5),
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      height: 100,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            fixedSize: const Size(300, 54),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            if (mounted) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => MainScreen()),
                                (route) => false,
                              );
                            }
                          },
                          child: Text(
                            "Continuer",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
