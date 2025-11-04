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
import 'package:m3fund_flutter/screens/home/user_payments_screen.dart';
import 'package:m3fund_flutter/screens/home/user_rewards_screen.dart';
import 'package:m3fund_flutter/services/contribution_service.dart';
import 'package:m3fund_flutter/services/payment_service.dart';
import 'package:m3fund_flutter/services/project_service.dart';
import 'package:m3fund_flutter/services/reward_winning_service.dart';
import 'package:m3fund_flutter/tools/utils.dart';
import 'package:remixicon/remixicon.dart';

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
  final ProjectService _projectService = ProjectService();
  double _totalPayments = .0;
  int _totalWinnedRewards = 0;
  int _contributedProjects = 0;
  List<PaymentResponse> _allPayments = [];
  List<RewardWinningResponse> _allRewards = [];
  String? _detailsMonth;
  double? _detailsAmount;
  List<Map<String, dynamic>> _lastFiveMonthsSummary = [];

  int? touchedIndex;

  List<Map<String, dynamic>> _data = [];

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
      var projects = await _projectService.getAllProjectsByCampaigns(
        uniqueProject.toList(),
      );
      setState(() {
        _totalPayments = total;
        _contributedProjects = uniqueProject.length;
        _totalWinnedRewards = allRewardsWinned.length;
        _allPayments = allPayments;
        _allRewards = allRewardsWinned;
        _data = generateProjectDomainStats(projects);
        _lastFiveMonthsSummary = summarizeLastFiveMonths(allPayments);
      });
    } catch (e) {
      showCustomTopSnackBar(context, e.toString(), color: Colors.redAccent);
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
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserPaymentsScreen(
                                  payments: sortPaymentsByDate(_allPayments),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 150,
                            height: 70,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Total Contribué",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Icon(
                                        RemixIcons.arrow_right_s_line,
                                        size: 24,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  "${formatToFrAmount(_totalPayments)} FCFA",
                                  style: TextStyle(
                                    fontSize: _totalPayments >= 10000000.0
                                        ? 18
                                        : 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
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
                    InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              UserRewardsScreen(rewards: _allRewards),
                        ),
                      ),
                      child: Container(
                        width: 220,
                        height: 70,
                        decoration: BoxDecoration(
                          color: customBlackColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total de récompenses gagnées",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Icon(
                                    RemixIcons.arrow_right_s_line,
                                    size: 24,
                                    color: Colors.white,
                                  ),
                                ],
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
                              color: Colors.black,
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
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Répartition des contributions par domaine",
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                    ),
                    _data.isEmpty
                        ? Center(
                            child: Text(
                              "Contribuer pour voir quelque chose",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black.withValues(alpha: 0.6),
                              ),
                            ),
                          )
                        : Column(
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
                                        if (!event
                                                .isInterestedForInteractions ||
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
    return List.generate(_data.length, (index) {
      final isTouched = index == touchedIndex;
      final double radius = isTouched ? 80 : 70;

      return PieChartSectionData(
        color: _data[index]['color'],
        value: roundTo2(_data[index]['value']),
        title: isTouched
            ? '${_data[index]['label']}\n${roundTo2(_data[index]['value'])}%'
            : '${roundTo2(_data[index]['value'])}%',
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
      children: _data.map((item) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: item['color'],
              ),
            ),
            const SizedBox(width: 6),
            Text(
              item['label'],
              style: TextStyle(
                fontSize: 12,
                color: Colors.black.withValues(alpha: 0.6),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  double roundTo2(double value) => (value * 100).roundToDouble() / 100;
}
