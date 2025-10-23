import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/models/requests/authentication_request.dart';
import 'package:m3fund_flutter/models/requests/create_contributor_request.dart';
import 'package:m3fund_flutter/models/responses/contributor_response.dart';

class AuthenticationService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String> _getValidAccessToken() async {
    var accessToken = await getAccessToken();

    if (accessToken != null) return accessToken;

    final refreshToken = await getRefreshToken();
    if (refreshToken == null) {
      throw Exception("Authentification requise.");
    }

    try {
      await refreshTokens();
    } catch (e) {
      throw Exception("Erreur lors du rafraîchissement du token: $e");
    }

    accessToken = await getAccessToken();
    if (accessToken == null) {
      throw Exception("Impossible de récupérer un token valide.");
    }
    return accessToken;
  }

  Future<http.Response> sendAuthorizedRequest(
    Future<http.Response> Function(String token) requestFunction,
  ) async {
    var token = await _getValidAccessToken();
    var response = await requestFunction(token);

    if (response.statusCode == 401) {
      try {
        await refreshTokens();
      } catch (e) {
        throw Exception(e);
      }
      token = await _getValidAccessToken();
      response = await requestFunction(token);
    }

    return response;
  }

  Future<ContributorResponse?> register({
    required CreateContributorRequest createContributorRequest,
  }) async {
    final url = Uri.parse("$baseUrl/auth/register/contributors");

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(createContributorRequest.toMap()),
    );

    if (response.statusCode == 201) {
      return ContributorResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  Future<void> login({
    required AuthenticationRequest authenticationRequest,
  }) async {
    final url = Uri.parse("$baseUrl/auth/login");

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(authenticationRequest.toMap()),
    );

    if (response.statusCode == 200) {
      final tokenPair = jsonDecode(response.body) as Map<String, dynamic>;
      await _saveTokens(
        refreshToken: tokenPair['refreshToken'],
        accessToken: tokenPair['accessToken'],
      );
    } else {
      throw Exception(response.body);
    }
  }

  Future<dynamic> checkForEmailAndPhoneValidity({
    required String email,
    required String phone,
  }) async {
    final url = Uri.parse("$baseUrl/public/valid-email-and-phone");
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(
        email.isEmpty ? {"phone": phone} : {"email": email, "phone": phone},
      ),
    );
    if (response.statusCode == 204) {
      return;
    } else {
      throw Exception(response.body);
    }
  }

  Future<void> refreshTokens() async {
    final url = Uri.parse("$baseUrl/auth/refresh");
    final refreshToken = await getRefreshToken();

    if (refreshToken == null) {
      throw Exception("Aucun refresh token trouvé");
    }

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({"refreshToken": refreshToken}),
    );

    if (response.statusCode == 200) {
      final tokenPair = jsonDecode(response.body) as Map<String, dynamic>;
      await _deleteTokens();
      await _saveTokens(
        refreshToken: tokenPair['refreshToken'],
        accessToken: tokenPair['accessToken'],
      );
    } else {
      throw Exception(response.body);
    }
  }

  Future<void> logout() async => _deleteTokens();

  Future<void> _saveTokens({
    required String refreshToken,
    required String accessToken,
  }) async {
    await _storage.write(key: 'refresh_token', value: refreshToken);
    await _storage.write(key: 'access_token', value: accessToken);
  }

  Future<String?> getRefreshToken() async =>
      _storage.read(key: 'refresh_token');

  Future<String?> getAccessToken() async => _storage.read(key: 'access_token');

  Future<void> _deleteTokens() async {
    await _storage.delete(key: 'refresh_token');
    await _storage.delete(key: 'access_token');
  }

  Map<String, String> get headers => {'Content-Type': 'application/json'};

  Map<String, String> tokenHeaders({required String token}) => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };
}
