import 'package:m3fund_flutter/models/enums/enums.dart';

class ProjectResponse {
  final int id;
  final String name;
  final String description;
  final String resume;
  final String objective;
  final ProjectDomain domain;
  final String websiteLink;
  final List<String> imagesUrl;
  final String videoUrl;
  final String businessPlanUrl;
  final DateTime launchedAt;
  final DateTime createdAt;
  final bool isValidated;

  ProjectResponse({
    required this.id,
    required this.name,
    required this.description,
    required this.resume,
    required this.objective,
    required this.domain,
    required this.websiteLink,
    required this.imagesUrl,
    required this.videoUrl,
    required this.businessPlanUrl,
    required this.launchedAt,
    required this.createdAt,
    required this.isValidated,
  });

  factory ProjectResponse.fromJson(Map<String, dynamic> jsonBody) {
    return ProjectResponse(
      id: jsonBody['id'] as int,
      name: jsonBody['name'] ?? '',
      description: jsonBody['description'] ?? '',
      resume: jsonBody['resume'] ?? '',
      objective: jsonBody['objective'] ?? '',
      domain: _projectDomainFromString(jsonBody['domain']),
      websiteLink: jsonBody['websiteLink'] ?? '',
      imagesUrl:
          (jsonBody['imagesUrl'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      videoUrl: jsonBody['videoUrl'] ?? '',
      businessPlanUrl: jsonBody['businessPlanUrl'] ?? '',
      launchedAt: DateTime.parse(jsonBody['launchedAt'].toString()),
      createdAt: DateTime.parse(jsonBody['createdAt'].toString()),
      isValidated: jsonBody['isValidated'] as bool? ?? false,
    );
  }

  static ProjectDomain _projectDomainFromString(String? domain) {
    switch (domain?.toUpperCase()) {
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
}
