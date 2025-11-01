import 'dart:convert';

import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/models/responses/payment_response.dart';
import 'package:m3fund_flutter/services/authentication_service.dart';
import 'package:http/http.dart' as http;

class PaymentService {
  final AuthenticationService _authenticationService = AuthenticationService();

  Future<List<PaymentResponse>> getMyPayments() async {
    final url = Uri.parse("$baseUrl/contributors/payments");
    final response = await _authenticationService.sendAuthorizedRequest(
      (token) => http.get(
        url,
        headers: _authenticationService.tokenHeaders(token: token),
      ),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      List<PaymentResponse> payments = [];
      for (var payment in data) {
        payments.add(PaymentResponse.fromJson(payment as Map<String, dynamic>));
      }
      return payments;
    } else {
      throw Exception(response.body);
    }
  }
}
