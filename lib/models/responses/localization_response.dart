class LocalizationResponse {
  int id;
  String country;
  String region;
  String town;
  String street;
  double longitude;
  double latitude;

  LocalizationResponse({
    required this.id,
    required this.country,
    required this.region,
    required this.town,
    required this.street,
    required this.longitude,
    required this.latitude,
  });

  factory LocalizationResponse.fromJson(Map<String, dynamic> jsonBody) {
    return LocalizationResponse(
      id: jsonBody['id'] as int,
      country: jsonBody['country'] ?? '',
      region: jsonBody['region'] ?? '',
      town: jsonBody['town'] ?? '',
      street: jsonBody['street'] ?? '',
      longitude: (jsonBody['longitude'] as num).toDouble(),
      latitude: (jsonBody['latitude'] as num).toDouble(),
    );
  }
}
