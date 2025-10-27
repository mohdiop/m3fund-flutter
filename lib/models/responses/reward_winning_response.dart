import 'package:m3fund_flutter/models/enums/enums.dart';
import 'package:m3fund_flutter/models/responses/reward_response.dart';

class RewardWinningResponse {
  final int id;
  final DateTime gainedAt;
  final RewardWinningState state;
  final RewardResponse reward;

  RewardWinningResponse({
    required this.id,
    required this.gainedAt,
    required this.state,
    required this.reward,
  });

  factory RewardWinningResponse.fromJson(Map<String, dynamic> jsonBody) {
    return RewardWinningResponse(
      id: jsonBody['id'] as int,
      gainedAt: DateTime.parse(jsonBody['gainedAt'].toString()),
      state: _rewardWinningStateFromString(jsonBody['state']),
      reward: RewardResponse.fromJson(jsonBody['reward']),
    );
  }

  static RewardWinningState _rewardWinningStateFromString(String? state) {
    switch (state?.toUpperCase()) {
      case 'PENDING':
        return RewardWinningState.pending;
      case 'GAINED':
        return RewardWinningState.gained;
      case 'CANCELED':
        return RewardWinningState.canceled;
      default:
        throw Exception("État de récompense inconnu: $state");
    }
  }
}
