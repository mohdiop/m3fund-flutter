import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/models/responses/campaign_response.dart';
import 'package:m3fund_flutter/screens/customs/custom_campaign_card.dart';
import 'package:m3fund_flutter/services/campaign_service.dart';

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
      child: Scrollbar(
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
                      PreferredSize(
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
                                        CustomCampaignCard(campaign: campaign),
                                    ],
                                  ),
                                ),
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
                    PreferredSize(
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
                                      CustomCampaignCard(campaign: campaign),
                                  ],
                                ),
                              ),
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
                    PreferredSize(
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
                                      CustomCampaignCard(campaign: campaign),
                                  ],
                                ),
                              ),
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
