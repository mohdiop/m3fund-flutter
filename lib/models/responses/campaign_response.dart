import 'package:m3fund_flutter/models/enums/enums.dart';
import 'package:m3fund_flutter/models/responses/project_response.dart';
import 'package:m3fund_flutter/models/responses/reward_response.dart';
import 'package:m3fund_flutter/models/responses/simple_owner_response.dart';

class CampaignResponse {
  final int id;
  final ProjectResponse projectResponse;
  final SimpleOwnerResponse owner;
  final DateTime launchedAt;
  final DateTime endAt;
  final double targetBudget;
  final int targetVolunteer;
  final double shareOffered;
  final CampaignType type;
  final CampaignState state;
  final List<RewardResponse> rewards;
  final double currentFund;

  CampaignResponse({
    required this.id,
    required this.projectResponse,
    required this.owner,
    required this.launchedAt,
    required this.endAt,
    required this.targetBudget,
    required this.targetVolunteer,
    required this.shareOffered,
    required this.type,
    required this.state,
    required this.rewards,
    required this.currentFund,
  });

  factory CampaignResponse.fromJson(Map<String, dynamic> jsonBody) {
    return CampaignResponse(
      id: jsonBody['id'] as int,
      projectResponse: ProjectResponse.fromJson(
        jsonBody['projectResponse'] as Map<String, dynamic>,
      ),
      owner: SimpleOwnerResponse.fromJson(
        jsonBody['owner'] as Map<String, dynamic>,
      ),
      launchedAt: DateTime.parse(jsonBody['launchedAt'].toString()),
      endAt: DateTime.parse(jsonBody['endAt'].toString()),
      targetBudget: (jsonBody['targetBudget'] as num).toDouble(),
      targetVolunteer: jsonBody['targetVolunteer'] as int,
      shareOffered: (jsonBody['shareOffered'] as num).toDouble(),
      type: _campaignTypeFromString(jsonBody['type']),
      state: _campaignStateFromString(jsonBody['state']),
      rewards: (jsonBody['rewards'] as List<dynamic>)
          .map((r) => RewardResponse.fromJson(r as Map<String, dynamic>))
          .toList(),
      currentFund: (jsonBody['currentFund'] as num).toDouble(),
    );
  }

  static CampaignType _campaignTypeFromString(String? type) {
    switch (type?.toUpperCase()) {
      case 'INVESTMENT':
        return CampaignType.investment;
      case 'VOLUNTEERING':
        return CampaignType.volunteering;
      case 'DONATION':
        return CampaignType.donation;
      default:
        throw Exception('Type de campagne inconnu: $type');
    }
  }

  static CampaignState _campaignStateFromString(String? state) {
    switch (state?.toUpperCase()) {
      case 'FINISHED':
        return CampaignState.finished;
      case 'IN_PROGRESS':
        return CampaignState.inProgress;
      default:
        throw Exception('État de campagne inconnu: $state');
    }
  }
}
