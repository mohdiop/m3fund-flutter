import 'dart:convert';

import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/models/responses/project_response.dart';
import 'package:m3fund_flutter/services/authentication_service.dart';
import 'package:http/http.dart' as http;

class ProjectService {
  final AuthenticationService _authenticationService = AuthenticationService();

  Future<List<ProjectResponse>> getAllProjectsByCampaigns(
    List<int> campaignsIds,
  ) async {
    final url = "$baseUrl/projects/campaigns/batch";
    final response = await _authenticationService.sendAuthorizedRequest(
      (token) => http.post(
        Uri.parse(url),
        headers: _authenticationService.tokenHeaders(token: token),
        body: jsonEncode(campaignsIds),
      ),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      List<ProjectResponse> projects = data
          .map(
            (project) =>
                ProjectResponse.fromJson(project as Map<String, dynamic>),
          )
          .toList();
      return projects;
    } else {
      throw Exception(response.statusCode);
    }
  }
}
