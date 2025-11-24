import 'dart:convert';

import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/models/responses/notification_response.dart';
import 'package:m3fund_flutter/services/authentication_service.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  final AuthenticationService _authenticationService = AuthenticationService();

  Future<List<NotificationResponse>> getMyNotifications() async {
    String url = "$baseUrl/notifications";
    var response = await _authenticationService.sendAuthorizedRequest(
      (token) => http.get(
        Uri.parse(url),
        headers: _authenticationService.tokenHeaders(token: token),
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map(
            (notification) => NotificationResponse.fromJson(
              notification as Map<String, dynamic>,
            ),
          )
          .toList();
    } else {
      throw Exception(response.body);
    }
  }

}
