import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/models/enums/enums.dart';
import 'package:m3fund_flutter/models/responses/campaign_response.dart';
import 'package:m3fund_flutter/screens/auth/login_screen.dart';
import 'package:m3fund_flutter/screens/customs/custom_campaign_card.dart';
import 'package:m3fund_flutter/services/campaign_service.dart';
import 'package:m3fund_flutter/tools/utils.dart';
import 'package:remixicon/remixicon.dart';

class CampaignsScreen extends StatefulWidget {
  final bool isAuthenticated;
  final String? userPosition;
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
  List<CampaignResponse> _campaigns = [];
  List<CampaignResponse> _campaignsFirstState = [];
  List<CampaignResponse> _recommendedCampaigns = [];
  List<CampaignResponse> _recommendedCampaignsFirstState = [];
  List<CampaignResponse> _newCampaigns = [];
  List<CampaignResponse> _newCampaignsFirstState = [];
  bool _errorOccuredWhenLoading = false;
  final ScrollController _firstScrollController = ScrollController();
  final ScrollController _secondScrollController = ScrollController();
  final ScrollController _thirdScrollController = ScrollController();
  final ScrollController _lastScrollController = ScrollController();
  final ScrollController _sortScrollController = ScrollController();

  final CampaignService _campaignService = CampaignService();

  int _currentDomain = -1;
  int _currentCampaignType = -1;

  @override
  void initState() {
    _loadCampaigns();
    super.initState();
  }

  Future<void> _loadCampaigns() async {
    setState(() {
      _isLoading = true;
    });
    try {
      _campaigns = await _campaignService.getAllCampaigns();
      _campaignsFirstState = _campaigns;
      _newCampaigns = await _campaignService.getNewCampaigns();
      _newCampaignsFirstState = _newCampaigns;
      if (widget.isAuthenticated) {
        _recommendedCampaigns = await _campaignService
            .getRecommendedCampaigns();
        _recommendedCampaignsFirstState = _recommendedCampaigns;
      }
    } catch (e) {
      showCustomTopSnackBar(context, e.toString(), color: Colors.redAccent);
      setState(() {
        _errorOccuredWhenLoading = true;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  List<Map<ProjectDomain, String>> domains = [
    {ProjectDomain.agriculture: "Agriculture"},
    {ProjectDomain.breeding: "Élevage"},
    {ProjectDomain.computerScience: "Informatique"},
    {ProjectDomain.culture: "Culture"},
    {ProjectDomain.education: "Éducation"},
    {ProjectDomain.environment: "Environnement"},
    {ProjectDomain.health: "Santé"},
    {ProjectDomain.mine: "Mine"},
    {ProjectDomain.shopping: "Commerce"},
    {ProjectDomain.social: "Social"},
    {ProjectDomain.solidarity: "Solidarité"},
  ];

  List<Map<CampaignType, String>> campaignTypes = [
    {CampaignType.donation: "Don"},
    {CampaignType.investment: "Investissement"},
    {CampaignType.volunteering: "Bénévolat"},
  ];

  _filterByDomain(ProjectDomain domain) {
    setState(() {
      _campaigns = _campaignsFirstState
          .where((campaign) => campaign.projectResponse.domain == domain)
          .toList();
      if (widget.isAuthenticated) {
        _recommendedCampaigns = _recommendedCampaignsFirstState
            .where((campaign) => campaign.projectResponse.domain == domain)
            .toList();
      }
      _newCampaigns = _newCampaignsFirstState
          .where((campaign) => campaign.projectResponse.domain == domain)
          .toList();
    });
  }

  _filterByType(CampaignType type) {
    setState(() {
      _campaigns = _campaignsFirstState
          .where((campaign) => campaign.type == type)
          .toList();
      if (widget.isAuthenticated) {
        _recommendedCampaigns = _recommendedCampaignsFirstState
            .where((campaign) => campaign.type == type)
            .toList();
      }
      _newCampaigns = _newCampaignsFirstState
          .where((campaign) => campaign.type == type)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 115),
      child: RefreshIndicator(
        onRefresh: () async {
          HapticFeedback.mediumImpact();
          await _loadCampaigns();
        },
        color: primaryColor,
        backgroundColor: Colors.white,
        displacement: 50,
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: ListView(
            physics: AlwaysScrollableScrollPhysics(),
            controller: _firstScrollController,
            padding: EdgeInsets.all(0),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 20,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: (MediaQuery.of(context).size.width - 340) / 2,
                      top: 60,
                    ),
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
                          width: 340,
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

                  PreferredSize(
                    preferredSize: Size(double.infinity, 32),
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(
                        context,
                      ).copyWith(scrollbars: false),
                      child: SingleChildScrollView(
                        controller: _sortScrollController,
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                (MediaQuery.of(context).size.width - 340) / 2,
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _currentDomain = -1;
                                    _campaigns = _campaignsFirstState;
                                    if (widget.isAuthenticated) {
                                      _recommendedCampaigns =
                                          _recommendedCampaignsFirstState;
                                    }
                                    _newCampaigns = _newCampaignsFirstState;
                                  });
                                  if (_currentCampaignType != -1) {
                                    _filterByType(
                                      campaignTypes[_currentCampaignType]
                                          .keys
                                          .first,
                                    );
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: _currentDomain == -1
                                        ? primaryColor
                                        : f4Grey,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Tous les domaines",
                                        style: TextStyle(
                                          color: _currentDomain == -1
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              for (var domain in domains)
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _currentDomain = domains.indexOf(domain);
                                    });
                                    _filterByDomain(domain.keys.first);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color:
                                          _currentDomain ==
                                              domains.indexOf(domain)
                                          ? primaryColor
                                          : f4Grey,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      spacing: 10,
                                      children: [
                                        Text(
                                          domain
                                              .values
                                              .first, // ← Récupère "Agriculture", "Élevage", etc.
                                          style: TextStyle(
                                            color:
                                                _currentDomain ==
                                                    domains.indexOf(domain)
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                        Icon(
                                          getDomainIcon(domain.keys.first),
                                          size: 18,
                                          color:
                                              _currentDomain ==
                                                  domains.indexOf(domain)
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  PreferredSize(
                    preferredSize: Size(double.infinity, 32),
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(
                        context,
                      ).copyWith(scrollbars: false),
                      child: SingleChildScrollView(
                        controller: _sortScrollController,
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                (MediaQuery.of(context).size.width - 340) / 2,
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _currentCampaignType = -1;
                                    _campaigns = _campaignsFirstState;
                                    if (widget.isAuthenticated) {
                                      _recommendedCampaigns =
                                          _recommendedCampaignsFirstState;
                                    }
                                    _newCampaigns = _newCampaignsFirstState;
                                  });
                                  if (_currentDomain != -1) {
                                    _filterByDomain(
                                      domains[_currentDomain].keys.first,
                                    );
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: _currentCampaignType == -1
                                        ? customBlackColor
                                        : f4Grey,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Toutes les campagnes",
                                        style: TextStyle(
                                          color: _currentCampaignType == -1
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              for (var campaign in campaignTypes)
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _currentCampaignType = campaignTypes
                                          .indexOf(campaign);
                                    });
                                    _filterByType(campaign.keys.first);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color:
                                          _currentCampaignType ==
                                              campaignTypes.indexOf(campaign)
                                          ? customBlackColor
                                          : f4Grey,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      spacing: 10,
                                      children: [
                                        Text(
                                          campaign.values.first,
                                          style: TextStyle(
                                            color:
                                                _currentCampaignType ==
                                                    campaignTypes.indexOf(
                                                      campaign,
                                                    )
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Nos récommendations
                  if (widget.isAuthenticated && widget.userPosition != null)
                    Container(
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(color: f4Grey),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal:
                                  (MediaQuery.of(context).size.width - 340) / 2,
                            ),
                            child: Text(
                              "Nos recommandations vers ${widget.userPosition}📍",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          _recommendedCampaigns.isNotEmpty
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
                                            controller: _secondScrollController,
                                            scrollDirection: Axis.horizontal,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    ((MediaQuery.of(
                                                              context,
                                                            ).size.width -
                                                            340) /
                                                        2) -
                                                    10,
                                              ),
                                              child: Row(
                                                children: [
                                                  for (var campaign
                                                      in _recommendedCampaigns)
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                          ),
                                                      child: CustomCampaignCard(
                                                        campaign: campaign,
                                                        isAuthenticated: widget
                                                            .isAuthenticated,
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                )
                              : _isLoading
                              ? Center(
                                  child: Column(
                                    children: [
                                      SpinKitSpinningLines(
                                        color: primaryColor,
                                        size: 32,
                                      ),
                                      Text(
                                        "Chargement ...",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.black.withValues(
                                            alpha: 0.6,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : _errorOccuredWhenLoading
                              ? Center(
                                  child: Text(
                                    "Impossible de charger les données depuis le serveur.",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black.withValues(
                                        alpha: 0.6,
                                      ),
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Text(
                                    "Pas de recommandations pour l'instant.",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black.withValues(
                                        alpha: 0.6,
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
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(color: f4Grey),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            left: (MediaQuery.of(context).size.width - 340) / 2,
                          ),
                          child: Text(
                            "Les nouvelles campagnes",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        _newCampaigns.isNotEmpty
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
                                          controller: _thirdScrollController,
                                          scrollDirection: Axis.horizontal,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  ((MediaQuery.of(
                                                            context,
                                                          ).size.width -
                                                          340) /
                                                      2) -
                                                  10,
                                            ),
                                            child: Row(
                                              children: [
                                                for (var campaign
                                                    in _newCampaigns)
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                        ),
                                                    child: CustomCampaignCard(
                                                      campaign: campaign,
                                                      isAuthenticated: widget
                                                          .isAuthenticated,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                              )
                            : _isLoading
                            ? Center(
                                child: Column(
                                  children: [
                                    SpinKitSpinningLines(
                                      color: primaryColor,
                                      size: 32,
                                    ),
                                    Text(
                                      "Chargement ...",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black.withValues(
                                          alpha: 0.6,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : _errorOccuredWhenLoading
                            ? Center(
                                child: Text(
                                  "Impossible de charger les données depuis le serveur.",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black.withValues(alpha: 0.6),
                                  ),
                                ),
                              )
                            : Center(
                                child: Text(
                                  "Pas de nouvelles campagnes pour l'instant.",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black.withValues(alpha: 0.6),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),

                  // Toutes les campagnes
                  Container(
                    alignment: Alignment.centerLeft,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(color: f4Grey),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            left: (MediaQuery.of(context).size.width - 340) / 2,
                          ),
                          child: Text(
                            "Toutes les campagnes",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        _campaigns.isNotEmpty
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
                                          controller: _lastScrollController,
                                          scrollDirection: Axis.horizontal,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  ((MediaQuery.of(
                                                            context,
                                                          ).size.width -
                                                          340) /
                                                      2) -
                                                  10,
                                            ),
                                            child: Row(
                                              children: [
                                                for (var campaign in _campaigns)
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                        ),
                                                    child: CustomCampaignCard(
                                                      campaign: campaign,
                                                      isAuthenticated: widget
                                                          .isAuthenticated,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                              )
                            : _isLoading
                            ? Center(
                                child: Column(
                                  children: [
                                    SpinKitSpinningLines(
                                      color: primaryColor,
                                      size: 32,
                                    ),
                                    Text(
                                      "Chargement ...",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black.withValues(
                                          alpha: 0.6,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : _errorOccuredWhenLoading
                            ? Center(
                                child: Text(
                                  "Impossible de charger les données depuis le serveur.",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black.withValues(alpha: 0.6),
                                  ),
                                ),
                              )
                            : Center(
                                child: Text(
                                  "Les rangs ne sont pas encore établis.",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black.withValues(alpha: 0.6),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
