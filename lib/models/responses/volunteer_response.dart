class VolunteerResponse {
  final int id;
  final int contributorId;
  final int campaignId;
  final DateTime date;

  VolunteerResponse({
    required this.id,
    required this.contributorId,
    required this.campaignId,
    required this.date,
  });

  factory VolunteerResponse.fromJson(Map<String, dynamic> jsonBody) {
    return VolunteerResponse(
      id: jsonBody['id'] as int,
      contributorId: jsonBody['contributorId'] as int,
      campaignId: jsonBody['campaignId'] as int,
      date: DateTime.parse(jsonBody['date'].toString()),
    );
  }
}
