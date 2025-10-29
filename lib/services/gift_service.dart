import 'dart:convert';

import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/models/requests/create/create_gift_request.dart';
import 'package:m3fund_flutter/models/responses/gift_response.dart';
import 'package:m3fund_flutter/services/authentication_service.dart';
import 'package:http/http.dart' as http;

class GiftService {
  final AuthenticationService _authenticationService = AuthenticationService();

  Future<dynamic> createGift({
    required int campaignId,
    required CreateGiftRequest gift,
  }) async {
    final url = Uri.parse("$baseUrl/projects/campaigns/$campaignId/gifts");
    final response = await _authenticationService.sendAuthorizedRequest(
      (token) => http.post(
        url,
        headers: _authenticationService.tokenHeaders(token: token),
        body: jsonEncode(gift.toMap()),
      ),
    );
    if (response.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return GiftResponse.fromJson(data);
    } else {
      throw Exception(response.body);
    }
  }
}
