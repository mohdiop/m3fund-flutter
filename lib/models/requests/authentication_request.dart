class AuthenticationRequest {
  String username;
  String password;

  AuthenticationRequest({required this.username, required this.password});

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
      'platform': 'MOBILE_CONTRIBUTOR',
    };
  }
}
