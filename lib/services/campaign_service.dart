import 'dart:convert';

import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/models/responses/campaign_response.dart';
import 'package:m3fund_flutter/services/authentication_service.dart';
import 'package:http/http.dart' as http;

class CampaignService {
  final AuthenticationService _authenticationService = AuthenticationService();

  Future<List<CampaignResponse>> getAllCampaigns() async {
    final url = Uri.parse("$baseUrl/public/campaigns");
    final response = await http.get(
      url,
      headers: _authenticationService.headers,
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map(
            (jsonCampaign) =>
                CampaignResponse.fromJson(jsonCampaign as Map<String, dynamic>),
          )
          .toList();
    } else {
      throw Exception(response.body);
    }
  }

  Future<List<CampaignResponse>> getNewCampaigns() async {
    final url = Uri.parse("$baseUrl/public/new-campaigns");
    final response = await http.get(
      url,
      headers: _authenticationService.headers,
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map(
            (jsonCampaign) =>
                CampaignResponse.fromJson(jsonCampaign as Map<String, dynamic>),
          )
          .toList();
    } else {
      throw Exception(response.body);
    }
  }

  Future<List<CampaignResponse>> getRecommendedCampaigns() async {
    final url = Uri.parse("$baseUrl/contributors/recommended-campaigns");
    final response = await _authenticationService.sendAuthorizedRequest(
      (token) => http.get(
        url,
        headers: _authenticationService.tokenHeaders(token: token),
      ),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map(
            (jsonCampaign) =>
                CampaignResponse.fromJson(jsonCampaign as Map<String, dynamic>),
          )
          .toList();
    } else {
      throw Exception(response.body);
    }
  }
}
