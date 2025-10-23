import 'package:m3fund_flutter/models/enums/enums.dart';

class UserPrefsManager {
  static final UserPrefsManager _instance = UserPrefsManager._internal();

  factory UserPrefsManager() => _instance;

  UserPrefsManager._internal();

  final List<CampaignType> campaignPrefs = [];
  final List<ProjectDomain> domainPrefs = [];

  void addCampaignPref(CampaignType pref) {
    if (!campaignPrefs.contains(pref)) {
      campaignPrefs.add(pref);
    }
  }

  void removeCampaignPref(CampaignType pref) {
    campaignPrefs.remove(pref);
  }

  void addDomainPref(ProjectDomain pref) {
    if (!domainPrefs.contains(pref)) {
      domainPrefs.add(pref);
    }
  }

  void removeDomainPref(ProjectDomain pref) {
    domainPrefs.remove(pref);
  }

  bool isSelected(dynamic pref) =>
      campaignPrefs.contains(pref) || domainPrefs.contains(pref);

  void clear() {
    campaignPrefs.clear();
    domainPrefs.clear();
  }
}
