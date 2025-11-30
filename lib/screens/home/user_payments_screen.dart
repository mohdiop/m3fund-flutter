import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/models/enums/enums.dart';
import 'package:m3fund_flutter/models/responses/payment_response.dart';
import 'package:m3fund_flutter/screens/home/campaign_details_screen.dart';
import 'package:m3fund_flutter/tools/utils.dart';
import 'package:remixicon/remixicon.dart';

class UserPaymentsScreen extends StatefulWidget {
  final List<PaymentResponse> payments;
  const UserPaymentsScreen({super.key, required this.payments});

  @override
  State<UserPaymentsScreen> createState() => _UserPaymentsScreenState();
}

class _UserPaymentsScreenState extends State<UserPaymentsScreen> {
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
                backgroundColor: Colors.white.withValues(alpha: 0.01),
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                toolbarHeight: 70,
                leadingWidth:
                    ((MediaQuery.of(context).size.width - 350) / 2) + 40,
                centerTitle: true,
                title: Text(
                  "Mes paiements",
                  style: const TextStyle(fontSize: 18, color: Colors.black),
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
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height / 4.5,
              bottom: 50,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 15,
              children: [
                for (var payment in widget.payments)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 10,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          spacing: 10,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              switch (payment.type) {
                                PaymentType.orangeMoney => "assets/om.png",
                                PaymentType.moovMoney => "assets/moov.png",
                                PaymentType.paypal => "assets/paypal.png",
                                PaymentType.bankCard => "assets/bank.png",
                              },
                              width: 44,
                              height: 44,
                            ),
                            SizedBox(
                              width: 200,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 5,
                                children: [
                                  RichText(
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      text: "Dépense dans ",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black.withValues(
                                          alpha: 0.6,
                                        ),
                                      ),
                                      children: [
                                        TextSpan(
                                          text: payment.projectName,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    "${switch (payment.type) {
                                      PaymentType.orangeMoney => "Orange Money",
                                      PaymentType.moovMoney => "Moov Money",
                                      PaymentType.paypal => "Paypal",
                                      PaymentType.bankCard => "Carte Bancaire",
                                    }} ~ ${timeElapsed(payment.madeAt)}",
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 80,
                              alignment: Alignment.centerRight,
                              child: Text(
                                "${formatToFrAmount(payment.amount)} FCFA",
                                style: TextStyle(
                                  fontSize: payment.amount >= 10000000
                                      ? 10
                                      : 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 350,
                        decoration: BoxDecoration(color: Color(0xFFD9D9D9)),
                        height: 1,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
