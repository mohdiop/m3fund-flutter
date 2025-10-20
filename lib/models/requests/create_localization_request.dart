class CreateLocalizationRequest {
  String region;
  String town;
  String street;
  double longitude;
  double latitude;

  CreateLocalizationRequest({
    required this.region,
    required this.town,
    required this.street,
    required this.longitude,
    required this.latitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'region': region,
      'town': town,
      'street': street,
      'longitude': longitude,
      'latitude': latitude,
    };
  }
}
