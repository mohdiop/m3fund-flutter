import 'package:m3fund_flutter/models/enums/enums.dart';
import 'package:m3fund_flutter/models/requests/create/create_localization_request.dart';

class UpdateContributorRequest {
  String? firstName;
  String? lastName;
  CreateLocalizationRequest? localization;
  List<ProjectDomain>? projectDomainPrefs;
  List<CampaignType>? campaignTypePrefs;
  String? email;
  String? phone;
  String? password;

  UpdateContributorRequest({
    this.firstName,
    this.lastName,
    this.localization,
    this.projectDomainPrefs,
    this.campaignTypePrefs,
    this.email,
    this.phone,
    this.password,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};

    if (firstName != null) data['firstName'] = firstName;
    if (lastName != null) data['lastName'] = lastName;
    if (localization != null) data['localization'] = localization!.toMap();
    if (projectDomainPrefs != null) {
      data['projectDomainPrefs'] = projectDomainPrefs!
          .map((domain) => _mapProjectDomainToBackend(domain))
          .toList();
    }
    if (campaignTypePrefs != null) {
      data['campaignTypePrefs'] = campaignTypePrefs!
          .map((campaign) => _mapCampaignTypeToBackend(campaign))
          .toList();
    }
    if (email != null) data['email'] = email;
    if (phone != null) data['phone'] = phone;
    if (password != null) data['password'] = password;

    return data;
  }

  static String _mapProjectDomainToBackend(ProjectDomain domain) {
    switch (domain) {
      case ProjectDomain.agriculture:
        return 'AGRICULTURE';
      case ProjectDomain.breeding:
        return 'BREEDING';
      case ProjectDomain.education:
        return 'EDUCATION';
      case ProjectDomain.health:
        return 'HEALTH';
      case ProjectDomain.mine:
        return 'MINE';
      case ProjectDomain.culture:
        return 'CULTURE';
      case ProjectDomain.environment:
        return 'ENVIRONMENT';
      case ProjectDomain.computerScience:
        return 'COMPUTER_SCIENCE';
      case ProjectDomain.solidarity:
        return 'SOLIDARITY';
      case ProjectDomain.shopping:
        return 'SHOPPING';
      case ProjectDomain.social:
        return 'SOCIAL';
    }
  }

  static String _mapCampaignTypeToBackend(CampaignType campaign) {
    switch (campaign) {
      case CampaignType.investment:
        return 'INVESTMENT';
      case CampaignType.volunteering:
        return 'VOLUNTEERING';
      case CampaignType.donation:
        return 'DONATION';
    }
  }
}
