import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/models/enums/enums.dart';
import 'package:m3fund_flutter/models/requests/create_gift_request.dart';
import 'package:m3fund_flutter/models/requests/create_payment_request.dart';
import 'package:m3fund_flutter/models/responses/campaign_response.dart';
import 'package:m3fund_flutter/models/responses/gift_response.dart';
import 'package:m3fund_flutter/screens/customs/custom_rewards_screen.dart';
import 'package:m3fund_flutter/screens/home/payment_success_screen.dart';
import 'package:m3fund_flutter/services/gift_service.dart';
import 'package:remixicon/remixicon.dart';
import 'package:uuid/uuid.dart';

class PaymentScreen extends StatefulWidget {
  final String contributionWord;
  final CampaignResponse campaignResponse;
  const PaymentScreen({
    super.key,
    required this.contributionWord,
    required this.campaignResponse,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _amountController = TextEditingController();
  final _paymentMethods = [
    {"name": "Orange Money", "asset": "assets/om.png"},
    {"name": "Moov Money", "asset": "assets/moov.png"},
    {"name": "Paypal", "asset": "assets/paypal.png"},
    {"name": "Carte bancaire", "asset": "assets/bank.png"},
  ];
  int _selectMethod = 0;

  bool _isBlankAmount = false;
  bool _isLoading = false;

  final GiftService _giftService = GiftService();
  final Uuid _uuid = Uuid();

  PaymentType _getPaymentType(int index) {
    switch (index) {
      case 0:
        return PaymentType.orangeMoney;
      case 1:
        return PaymentType.moovMoney;
      case 2:
        return PaymentType.paypal;
      case 3:
        return PaymentType.bankCard;
      default:
        return PaymentType.orangeMoney;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                title: Center(
                  child: Text(
                    "${widget.contributionWord} ${widget.campaignResponse.projectResponse.name}",
                    style: const TextStyle(fontSize: 24, color: Colors.black),
                  ),
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
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Stack(
        children: [
          ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(scrollbars: false),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 60),
                  if (widget.campaignResponse.type == CampaignType.donation)
                    CustomRewardsScreen(
                      rewards: widget.campaignResponse.rewards,
                    ),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Choisissez votre montant",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      if (_isBlankAmount)
                        Text(
                          "Veuillez fournir un montant",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                          ),
                        ),
                      if (_isBlankAmount) SizedBox(height: 10),
                      SizedBox(
                        height: 62,
                        width: 300,
                        child: TextField(
                          controller: _amountController,
                          style: const TextStyle(fontSize: 12),
                          onTap: () {
                            setState(() {
                              _isBlankAmount = false;
                            });
                          },
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: false,
                            signed: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            hintText: "Ex: 10000",
                            hintStyle: TextStyle(
                              color: _isBlankAmount
                                  ? Colors.red.shade300
                                  : Colors.grey,
                              fontSize: 12,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: _isBlankAmount
                                    ? Colors.red
                                    : customBlackColor,
                                width: 2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFF06A664),
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 23,
                            ),
                            suffixIconConstraints: BoxConstraints(
                              maxHeight: 50,
                              maxWidth: 50,
                            ),
                            suffixIcon: Center(
                              child: Text(
                                "FCFA",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _isBlankAmount
                                      ? Colors.red
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          cursorColor: const Color(0xFF06A664),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Choisissez votre méthode de paiement",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      Column(
                        spacing: 10,
                        children: _paymentMethods
                            .map(
                              (paymentMethod) => GestureDetector(
                                onTap: () => setState(() {
                                  _selectMethod = _paymentMethods.indexOf(
                                    paymentMethod,
                                  );
                                }),
                                child: Container(
                                  height: 54,
                                  width: 300,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(10),
                                    color: f4Grey,
                                    border: BoxBorder.all(
                                      color:
                                          _paymentMethods.indexOf(
                                                paymentMethod,
                                              ) !=
                                              _selectMethod
                                          ? Colors.grey.shade300
                                          : primaryColor,
                                      width: 2,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Image.asset(
                                        paymentMethod["asset"]!,
                                        width: 40,
                                        height: 40,
                                      ),
                                      SizedBox(
                                        width: 200,
                                        child: Text(paymentMethod["name"]!),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color:
                                              _paymentMethods.indexOf(
                                                    paymentMethod,
                                                  ) !=
                                                  _selectMethod
                                              ? Colors.white
                                              : primaryColor,
                                          shape: BoxShape.circle,
                                        ),
                                        height: 24,
                                        width: 24,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                  SizedBox(height: 120),
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
                        backgroundColor: _isLoading
                            ? Colors.white
                            : primaryColor,
                        foregroundColor: Colors.white,
                        fixedSize: const Size(300, 54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        if (_amountController.text.trim().isEmpty) {
                          setState(() {
                            _isBlankAmount = true;
                          });
                        } else {
                          setState(() {
                            _isLoading = true;
                          });
                          try {
                            GiftResponse giftResponse = await _giftService
                                .createGift(
                                  campaignId: widget.campaignResponse.id,
                                  gift: CreateGiftRequest(
                                    payment: CreatePaymentRequest(
                                      transactionId: _uuid.v4(),
                                      type: _getPaymentType(_selectMethod),
                                      state: PaymentState.success,
                                      amount: double.parse(
                                        _amountController.text.toString(),
                                      ),
                                    ),
                                  ),
                                );
                            if (mounted) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PaymentSuccessScreen(
                                    giftResponse: giftResponse,
                                  ),
                                ),
                                (route) => false,
                              );
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          } catch (e) {
                            setState(() {
                              _isLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        }
                      },
                      child: _isLoading
                          ? Center(
                              child: SpinKitSpinningLines(
                                color: primaryColor,
                                size: 32,
                              ),
                            )
                          : const Text(
                              "Procéder au paiement",
                              style: TextStyle(fontSize: 24),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
