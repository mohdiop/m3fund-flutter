import 'package:m3fund_flutter/models/enums/enums.dart';
import 'package:m3fund_flutter/models/requests/create/create_localization_request.dart';

class CreateContributorRequest {
  final String firstName;
  final String lastName;
  CreateLocalizationRequest? localization;
  List<ProjectDomain>? projectDomainPrefs;
  List<CampaignType>? campaignTypePrefs;
  final String email;
  final String phone;
  final String password;

  CreateContributorRequest({
    required this.firstName,
    required this.lastName,
    this.localization,
    this.projectDomainPrefs,
    this.campaignTypePrefs,
    required this.email,
    required this.phone,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'localization': localization?.toMap(),
      'projectDomainPrefs': projectDomainPrefs
          ?.map((domain) => _mapProjectDomainToBackend(domain))
          .toList(),
      'campaignTypePrefs': campaignTypePrefs
          ?.map((campaign) => _mapCampaignTypeToBackend(campaign))
          .toList(),
      'email': email,
      'phone': phone,
      'password': password,
    };
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
