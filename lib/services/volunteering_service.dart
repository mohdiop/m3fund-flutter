import 'dart:convert';

import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/services/authentication_service.dart';
import 'package:http/http.dart' as http;

class VolunteeringService {
  final AuthenticationService _authenticationService = AuthenticationService();

  Future<bool> createVolunteering(int campaignId) async {
    final url = '$baseUrl/projects/campaigns/$campaignId/volunteers';
    final response = await _authenticationService.sendAuthorizedRequest(
      (token) => http.post(
        Uri.parse(url),
        headers: _authenticationService.tokenHeaders(token: token),
      ),
    );

    if (response.statusCode != 201) {
      throw Exception(response.body);
    }
    return jsonDecode(response.body) as bool;
  }
}
