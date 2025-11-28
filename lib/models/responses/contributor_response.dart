import 'package:m3fund_flutter/models/enums/enums.dart';
import 'package:m3fund_flutter/models/responses/localization_response.dart';

class ContributorResponse {
  final int id;
  final String firstName;
  final String lastName;
  final LocalizationResponse? localization;
  final List<ProjectDomain> projectDomainPrefs;
  final List<CampaignType> campaignTypePrefs;
  final String email;
  final String phone;
  final DateTime createdAt;
  final List<UserRole> roles;

  ContributorResponse({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.localization,
    required this.projectDomainPrefs,
    required this.campaignTypePrefs,
    required this.email,
    required this.phone,
    required this.createdAt,
    required this.roles,
  });

  factory ContributorResponse.fromJson(Map<String, dynamic> jsonBody) {
    return ContributorResponse(
      id: jsonBody['id'] as int,
      firstName: jsonBody['firstName'] ?? '',
      lastName: jsonBody['lastName'] ?? '',
      localization: jsonBody['localization'] == null
          ? null
          : LocalizationResponse.fromJson(
              jsonBody['localization'] as Map<String, dynamic>,
            ),
      projectDomainPrefs: (jsonBody['projectDomainPrefs'] as List)
          .map((domain) => _projectDomainFromString(domain))
          .toList(),
      campaignTypePrefs: (jsonBody['campaignTypePrefs'] as List)
          .map((type) => _campaignTypeFromString(type))
          .toList(),
      email: jsonBody['email'] ?? '',
      phone: jsonBody['phone'] ?? '',
      createdAt: DateTime.parse(jsonBody['createdAt'].toString()),
      roles: (jsonBody['roles'] as List)
          .map((roleString) => _roleFromString(roleString))
          .toList(),
    );
  }

  static UserRole _roleFromString(String role) {
    switch (role) {
      case 'ROLE_SUPER_ADMIN':
        return UserRole.superAdmin;
      case 'ROLE_SYSTEM':
        return UserRole.system;
      case 'ROLE_VALIDATIONS_ADMIN':
        return UserRole.validationsAdmin;
      case 'ROLE_PAYMENTS_ADMIN':
        return UserRole.paymentsAdmin;
      case 'ROLE_USERS_ADMIN':
        return UserRole.usersAdmin;
      case 'ROLE_CONTRIBUTOR':
        return UserRole.contributor;
      case 'ROLE_PROJECT_OWNER':
        return UserRole.projectOwner;
      default:
        throw Exception("Rôle inconnu: $role");
    }
  }

  static ProjectDomain _projectDomainFromString(String domain) {
    switch (domain.toUpperCase()) {
      case 'AGRICULTURE':
        return ProjectDomain.agriculture;
      case 'BREEDING':
        return ProjectDomain.breeding;
      case 'EDUCATION':
        return ProjectDomain.education;
      case 'HEALTH':
        return ProjectDomain.health;
      case 'MINE':
        return ProjectDomain.mine;
      case 'CULTURE':
        return ProjectDomain.culture;
      case 'ENVIRONMENT':
        return ProjectDomain.environment;
      case 'COMPUTER_SCIENCE':
        return ProjectDomain.computerScience;
      case 'SOLIDARITY':
        return ProjectDomain.solidarity;
      case 'SHOPPING':
        return ProjectDomain.shopping;
      case 'SOCIAL':
        return ProjectDomain.social;
      default:
        throw Exception("Domaine de projet inconnu: $domain");
    }
  }

  static CampaignType _campaignTypeFromString(String type) {
    switch (type.toUpperCase()) {
      case 'INVESTMENT':
        return CampaignType.investment;
      case 'VOLUNTEERING':
        return CampaignType.volunteering;
      case 'DONATION':
        return CampaignType.donation;
      default:
        throw Exception("Type de campagne inconnu: $type");
    }
  }
}
