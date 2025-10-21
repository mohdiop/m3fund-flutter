class SimpleOwnerResponse {
  final int id;
  final String name;
  final String profileUrl;

  SimpleOwnerResponse({
    required this.id,
    required this.name,
    required this.profileUrl,
  });

  factory SimpleOwnerResponse.fromJson(Map<String, dynamic> jsonBody) {
    return SimpleOwnerResponse(
      id: jsonBody['id'] as int,
      name: jsonBody['name'] ?? '',
      profileUrl: jsonBody['profileUrl'] ?? '',
    );
  }
}

