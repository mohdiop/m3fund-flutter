import 'dart:collection';
import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/models/responses/payment_response.dart';
import 'package:m3fund_flutter/models/responses/reward_winning_response.dart';
import 'package:m3fund_flutter/screens/customs/custom_payments_stats_chart.dart';
import 'package:m3fund_flutter/screens/customs/custom_request_auth_page.dart';
import 'package:m3fund_flutter/screens/home/campaign_details_screen.dart';
import 'package:m3fund_flutter/services/contribution_service.dart';
import 'package:m3fund_flutter/services/payment_service.dart';
import 'package:m3fund_flutter/services/reward_winning_service.dart';
import 'package:m3fund_flutter/tools/utils.dart';

class StatsScreen extends StatefulWidget {
  final bool isAuthenticated;
  const StatsScreen({super.key, required this.isAuthenticated});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final PaymentService _paymentService = PaymentService();
  final RewardWinningService _rewardWinningService = RewardWinningService();
  final ContributionService _contributionService = ContributionService();
  double _totalPayments = .0;
  int _totalWinnedRewards = 0;
  int _contributedProjects = 0;
  List<PaymentResponse> _allPayments = [];
  List<RewardWinningResponse> _allRewards = [];
  String? _detailsMonth;
  double? _detailsAmount;
  List<Map<String, dynamic>> _lastFiveMonthsSummary = [];

  int? touchedIndex;

  final List<Map<String, dynamic>> data = [
    {'label': 'Éducation', 'value': 25.0, 'color': Colors.teal},
    {'label': 'Santé', 'value': 30.0, 'color': Colors.lightBlue},
    {'label': 'Agriculture', 'value': 45.0, 'color': Colors.orange},
  ];

  Future<void> _loadUserStats() async {
    try {
      var allPayments = await _paymentService.getMyPayments();
      var allRewardsWinned = await _rewardWinningService.getMyWinnedRewards();
      var contributions = await _contributionService.getMyContributions();
      double total = .0;
      for (var payment in allPayments) {
        total = total + payment.amount;
      }
      Set<int> uniqueProject = HashSet();
      for (var gift in contributions.gifts) {
        uniqueProject.add(gift.campaignId);
      }
      for (var volunteering in contributions.volunteering) {
        uniqueProject.add(volunteering.campaignId);
      }
      setState(() {
        _totalPayments = total;
        _contributedProjects = uniqueProject.length;
        _totalWinnedRewards = allRewardsWinned.length;
        _allPayments = allPayments;
        _allRewards = allRewardsWinned;
        _lastFiveMonthsSummary = summarizeLastFiveMonths(allPayments);
      });
    } catch (e) {
      showCustomTopSnackBar(context, e.toString());
    }
  }

  @override
  void initState() {
    if (widget.isAuthenticated) {
      _loadUserStats();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return !widget.isAuthenticated
        ? CustomRequestAuthPage(sectionName: "Statistiques")
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                  child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: AppBar(
                      backgroundColor: Colors.transparent,
                      surfaceTintColor: Colors.transparent,
                      leading: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          "Statistiques",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      leadingWidth: 300,
                    ),
                  ),
                ),
              ),
            ),
            extendBody: true,
            extendBodyBehindAppBar: true,
            body: ScrollConfiguration(
              behavior: ScrollConfiguration.of(
                context,
              ).copyWith(scrollbars: false),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 20,
                  children: [
                    SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 20,
                      children: [
                        Container(
                          width: 150,
                          height: 70,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Total Contribué",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "${formatToFrAmount(_totalPayments)} FCFA",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 150,
                          height: 70,
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Total de projets soutenus",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "$_contributedProjects",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 200,
                      height: 70,
                      decoration: BoxDecoration(
                        color: customBlackColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Total de récompenses gagnées",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "$_totalWinnedRewards",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      child: Text(
                        "Répartition des montants contribués pendant les cinq derniers mois",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      width: 320,
                      height: 200,
                      child: CustomPaymentsStatsChart(
                        action: (month, amount) {
                          setState(() {
                            _detailsMonth = month;
                            _detailsAmount = amount;
                          });
                        },
                        data: _lastFiveMonthsSummary,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: "En ",
                        style: TextStyle(fontSize: 12, color: Colors.black),
                        children: [
                          TextSpan(
                            text: _detailsMonth ?? "(mois)",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black.withValues(alpha: 0.6),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: " vous avez dépensé ",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black.withValues(alpha: 0.6),
                            ),
                          ),
                          TextSpan(
                            text:
                                "${formatToFrAmount(_detailsAmount ?? 0)} FCFA",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black.withValues(alpha: 0.6),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 250,
                          width: 250,
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 2,
                              centerSpaceRadius: 40,
                              pieTouchData: PieTouchData(
                                touchCallback: (event, response) {
                                  if (!event.isInterestedForInteractions ||
                                      response == null ||
                                      response.touchedSection == null) {
                                    setState(() {
                                      touchedIndex = null;
                                    });
                                    return;
                                  }
                                  setState(() {
                                    touchedIndex = response
                                        .touchedSection!
                                        .touchedSectionIndex;
                                  });
                                },
                              ),
                              sections: _buildSections(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildLegend(),
                      ],
                    ),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          );
  }

  List<PieChartSectionData> _buildSections() {
    return List.generate(data.length, (index) {
      final isTouched = index == touchedIndex;
      final double radius = isTouched ? 80 : 70;

      return PieChartSectionData(
        color: data[index]['color'],
        value: data[index]['value'],
        title: isTouched
            ? '${data[index]['label']}\n${data[index]['value']}%'
            : '${data[index]['value']}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: isTouched ? 15 : 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }

  Widget _buildLegend() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 20,
      children: data.map((item) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 14, height: 14, color: item['color']),
            const SizedBox(width: 6),
            Text(item['label']),
          ],
        );
      }).toList(),
    );
  }
}
