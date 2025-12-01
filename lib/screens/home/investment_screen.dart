import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/models/responses/campaign_response.dart';
import 'package:remixicon/remixicon.dart';

class InvestmentScreen extends StatefulWidget {
  final CampaignResponse campaign;
  const InvestmentScreen({super.key, required this.campaign});

  @override
  State<InvestmentScreen> createState() => _InvestmentScreenState();
}

class _InvestmentScreenState extends State<InvestmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: AppBar(
                backgroundColor: Colors.white.withValues(alpha: 0.01),
                surfaceTintColor: Colors.transparent,
                toolbarHeight: 50,
                leadingWidth:
                    ((MediaQuery.of(context).size.width - 350) / 2) + 40,
                centerTitle: true,
                title: Text(
                  "Investir dans ${widget.campaign.projectResponse.name}",
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
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Center(child: Text("INVESTMENT")),
    );
  }
}
