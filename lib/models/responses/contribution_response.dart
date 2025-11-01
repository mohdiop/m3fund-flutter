import 'package:m3fund_flutter/models/responses/gift_response.dart';
import 'package:m3fund_flutter/models/responses/volunteer_response.dart';

class ContributionResponse {
  final Set<GiftResponse> gifts;
  final Set<VolunteerResponse> volunteering;

  ContributionResponse({required this.gifts, required this.volunteering});

  factory ContributionResponse.fromJson(Map<String, dynamic> jsonBody) {
    return ContributionResponse(
      gifts: ((jsonBody['gifts'] as List<dynamic>?) ?? [])
          .map((e) => GiftResponse.fromJson(e as Map<String, dynamic>))
          .toSet(),
      volunteering: ((jsonBody['volunteering'] as List<dynamic>?) ?? [])
          .map((e) => VolunteerResponse.fromJson(e as Map<String, dynamic>))
          .toSet(),
    );
  }
}
