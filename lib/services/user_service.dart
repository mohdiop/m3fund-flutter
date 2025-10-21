import 'dart:convert';

import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/models/responses/contributor_response.dart';
import 'package:m3fund_flutter/services/authentication_service.dart';
import 'package:http/http.dart' as http;

class UserService {
  final AuthenticationService _authenticationService = AuthenticationService();

  Future<dynamic> me() async {
    final url = Uri.parse("$baseUrl/users/me");
    final response = await _authenticationService.sendAuthorizedRequest(
      (token) => http.get(url, headers: _authenticationService.tokenHeaders(token: token)),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return ContributorResponse.fromJson(data);
    } else {
      throw Exception(response.body);
    }
  }
}
