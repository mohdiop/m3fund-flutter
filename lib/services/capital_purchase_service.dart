import 'dart:convert';

import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/models/requests/create/create_capital_purchase_request.dart';
import 'package:m3fund_flutter/models/responses/capital_purchase_response.dart';
import 'package:m3fund_flutter/services/authentication_service.dart';
import 'package:http/http.dart' as http;

class CapitalPurchaseService {
  final AuthenticationService _authenticationService = AuthenticationService();

  Future<CapitalPurchaseResponse> createPurchase({
    required int campaignId,
    required CreateCapitalPurchaseRequest purchase,
  }) async {
    final url = Uri.parse("$baseUrl/projects/campaigns/$campaignId/capital-purchases");
    final response = await _authenticationService.sendAuthorizedRequest(
      (token) => http.post(
        url,
        headers: _authenticationService.tokenHeaders(token: token),
        body: jsonEncode(purchase.toMap()),
      ),
    );
    if (response.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return CapitalPurchaseResponse.fromJson(data);
    } else {
      throw Exception(response.body);
    }
  }
}
