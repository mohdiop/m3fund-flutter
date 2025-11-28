import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/models/enums/enums.dart';
import 'package:m3fund_flutter/models/requests/create/create_contributor_request.dart';
import 'package:m3fund_flutter/screens/auth/request_position_screen.dart';
import 'package:m3fund_flutter/screens/customs/custom_pref_chooser.dart';
import 'package:m3fund_flutter/tools/user_prefs_manager.dart';
import 'package:remixicon/remixicon.dart';

class UserPrefsScreen extends StatefulWidget {
  final CreateContributorRequest contributorRequest;
  const UserPrefsScreen({super.key, required this.contributorRequest});

  @override
  State<UserPrefsScreen> createState() => _UserPrefsScreenState();
}

class _UserPrefsScreenState extends State<UserPrefsScreen> {
  final UserPrefsManager _userPrefsManager = UserPrefsManager();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _userPrefsManager.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.white.withValues(alpha: 0.01),
        surfaceTintColor: Colors.transparent,
        leadingWidth: ((MediaQuery.of(context).size.width - 350) / 2) + 43,
        leading: Padding(
          padding: EdgeInsets.only(
            left: (MediaQuery.of(context).size.width - 350) / 2,
          ),
          child: IconButton(
            style: IconButton.styleFrom(
              backgroundColor: primaryColor,
              shape: const CircleBorder(),
            ),
            icon: Icon(
              RemixIcons.arrow_left_line,
              size: 24,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Center(
            child: SizedBox(
              width: 339,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Partagez nous vos préférences",
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 30),
                  Text(
                    "Les types de contribution que vous aimeriez voir",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(0, 0, 0, 0.6),
                    ),
                  ),
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    children: [
                      CustomPrefChooser(
                        icon: RemixIcons.hand_coin_line,
                        text: "Don",
                        prefType: CampaignType.donation,
                      ),
                      CustomPrefChooser(
                        icon: RemixIcons.group_3_line,
                        text: "Bénévolat",
                        prefType: CampaignType.volunteering,
                      ),
                      CustomPrefChooser(
                        icon: RemixIcons.funds_box_line,
                        text: "Investissement",
                        prefType: CampaignType.investment,
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Text(
                    "Les types de projets qui vous interessent",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(0, 0, 0, 0.6),
                    ),
                  ),
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    children: [
                      CustomPrefChooser(
                        icon: RemixIcons.flower_line,
                        text: "Agriculture",
                        prefType: ProjectDomain.agriculture,
                      ),
                      CustomPrefChooser(
                        icon: RemixIcons.building_2_line,
                        text: "Mine",
                        prefType: ProjectDomain.mine,
                      ),
                      CustomPrefChooser(
                        icon: RemixIcons.heart_2_line,
                        text: "Santé",
                        prefType: ProjectDomain.health,
                      ),
                      CustomPrefChooser(
                        icon: RemixIcons.graduation_cap_line,
                        text: "Education",
                        prefType: ProjectDomain.education,
                      ),
                      CustomPrefChooser(
                        icon: RemixIcons.mac_line,
                        text: "Informatique",
                        prefType: ProjectDomain.computerScience,
                      ),
                      CustomPrefChooser(
                        icon: RemixIcons.leaf_line,
                        text: "Environnement",
                        prefType: ProjectDomain.environment,
                      ),
                      CustomPrefChooser(
                        icon: RemixIcons.service_line,
                        text: "Solidarité",
                        prefType: ProjectDomain.solidarity,
                      ),
                      CustomPrefChooser(
                        icon: MdiIcons.sheep,
                        text: "Elevage",
                        prefType: ProjectDomain.breeding,
                      ),
                      CustomPrefChooser(
                        icon: MdiIcons.accountGroup,
                        text: "Social",
                        prefType: ProjectDomain.social,
                      ),
                      CustomPrefChooser(
                        icon: RemixIcons.shopping_cart_line,
                        text: "Course",
                        prefType: ProjectDomain.shopping,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            spacing: 15,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: f4Grey,
                  foregroundColor: Colors.black,
                  fixedSize: Size(160, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text("Passer", style: TextStyle(fontSize: 20)),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => RequestPositionScreen(
                        contributor: widget.contributorRequest,
                      ),
                    ),
                  );
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  fixedSize: Size(160, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text("Continuer", style: TextStyle(fontSize: 20)),
                onPressed: () {
                  if (_userPrefsManager.campaignPrefs.isEmpty &&
                      _userPrefsManager.domainPrefs.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Pour continuer, choisissez au moins une préférence.",
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: primaryColor,
                        duration: Duration(seconds: 3),
                      ),
                    );
                  } else {
                    widget.contributorRequest.campaignTypePrefs.addAll(
                      _userPrefsManager.campaignPrefs,
                    );
                    widget.contributorRequest.projectDomainPrefs.addAll(
                      _userPrefsManager.domainPrefs,
                    );
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RequestPositionScreen(
                          contributor: widget.contributorRequest,
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
