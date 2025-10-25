class AuthenticationRequest {
  String email;
  String password;

  AuthenticationRequest({required this.email, required this.password});

  Map<String, dynamic> toMap() {
    return {'email': email, 'password': password, 'platform': 'MOBILE_CONTRIBUTOR'};
  }
}