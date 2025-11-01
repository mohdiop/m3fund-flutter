import 'dart:convert';

import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/models/responses/reward_winning_response.dart';
import 'package:m3fund_flutter/services/authentication_service.dart';
import 'package:http/http.dart' as http;

class RewardWinningService {
  final AuthenticationService _authenticationService = AuthenticationService();

  Future<List<RewardWinningResponse>> getMyWinnedRewards() async {
    final url = Uri.parse("$baseUrl/contributors/rewards-won");
    final response = await _authenticationService.sendAuthorizedRequest(
      (token) => http.get(
        url,
        headers: _authenticationService.tokenHeaders(token: token),
      ),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      List<RewardWinningResponse> rewardsWinned = [];
      for (var rewardWinned in data) {
        rewardsWinned.add(RewardWinningResponse.fromJson(rewardWinned as Map<String, dynamic>));
      }
      return rewardsWinned;
    } else {
      throw Exception(response.body);
    }
  }
}
