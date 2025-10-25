import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/models/responses/campaign_response.dart';
import 'package:m3fund_flutter/screens/auth/login_screen.dart';
import 'package:m3fund_flutter/screens/customs/custom_campaign_card.dart';
import 'package:m3fund_flutter/services/campaign_service.dart';
import 'package:remixicon/remixicon.dart';

class CampaignsScreen extends StatefulWidget {
  final bool isAuthenticated;
  final String userPosition;
  const CampaignsScreen({
    super.key,
    required this.isAuthenticated,
    required this.userPosition,
  });

  @override
  State<CampaignsScreen> createState() => _CampaignsScreenState();
}

class _CampaignsScreenState extends State<CampaignsScreen> {
  bool _isLoading = false;
  List<CampaignResponse> campaigns = [];

  final CampaignService _campaignService = CampaignService();

  @override
  void initState() {
    _loadCampaigns();
    super.initState();
  }

  Future<void> _loadCampaigns() async {
    setState(() {
      _isLoading = true;
    });
    campaigns = await _campaignService.getAllCampaigns();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 115),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "Découvrir des projets",
                  style: TextStyle(fontSize: 20),
                ),
              ),

              if (!widget.isAuthenticated)
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => LoginScreen()),
                        (_) => false,
                      );
                    },
                    child: Container(
                      width: 350,
                      height: 44,
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            LineAwesomeIcons.user_slash_solid,
                            size: 24,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 270,
                            child: Text(
                              "Vous n’êtes pas connecté! Pour contribuer aux projets innovants, veuillez vous authentifier.",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
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
                  ),
                ),

              // Nos récommendations
              if (widget.isAuthenticated)
                Container(
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(color: f4Grey),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nos recommandations vers ${widget.userPosition}📍",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      campaigns.isNotEmpty
                          ? PreferredSize(
                              preferredSize: Size(double.infinity, 250),
                              child: _isLoading
                                  ? Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: SpinKitSpinningLines(
                                        color: primaryColor,
                                        size: 64,
                                      ),
                                    )
                                  : ScrollConfiguration(
                                      behavior: ScrollConfiguration.of(
                                        context,
                                      ).copyWith(scrollbars: false),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          spacing: 30,
                                          children: [
                                            for (var campaign in campaigns)
                                              CustomCampaignCard(
                                                campaign: campaign,
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                            )
                          : Center(
                              child: Text(
                                "Pas de recommandations pour l'instant.",
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                    ],
                  ),
                ),

              // Les nouvelles campagnes
              Container(
                alignment: Alignment.centerLeft,
                width: double.infinity,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color: f4Grey),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Les nouvelles campagnes",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    campaigns.isNotEmpty
                        ? PreferredSize(
                            preferredSize: Size(double.infinity, 250),
                            child: _isLoading
                                ? Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: SpinKitSpinningLines(
                                      color: primaryColor,
                                      size: 64,
                                    ),
                                  )
                                : ScrollConfiguration(
                                    behavior: ScrollConfiguration.of(
                                      context,
                                    ).copyWith(scrollbars: false),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        spacing: 30,
                                        children: [
                                          for (var campaign in campaigns)
                                            CustomCampaignCard(
                                              campaign: campaign,
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                          )
                        : Center(
                            child: Text(
                              "Pas de nouvelles campagnes pour l'instant.",
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                  ],
                ),
              ),

              // Les plus soutenus
              Container(
                alignment: Alignment.centerLeft,
                width: double.infinity,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color: f4Grey),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Les plus soutenus",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    campaigns.isNotEmpty
                        ? PreferredSize(
                            preferredSize: Size(double.infinity, 250),
                            child: _isLoading
                                ? Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: SpinKitSpinningLines(
                                      color: primaryColor,
                                      size: 64,
                                    ),
                                  )
                                : ScrollConfiguration(
                                    behavior: ScrollConfiguration.of(
                                      context,
                                    ).copyWith(scrollbars: false),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        spacing: 30,
                                        children: [
                                          for (var campaign in campaigns)
                                            CustomCampaignCard(
                                              campaign: campaign,
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                          )
                        : Center(
                            child: Text(
                              "Les rangs ne sont pas encore établis.",
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                  ],
                ),
              ),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
