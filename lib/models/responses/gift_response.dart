import 'package:m3fund_flutter/models/responses/payment_response.dart';
import 'package:m3fund_flutter/models/responses/reward_winning_response.dart';

class GiftResponse {
  final int id;
  final int campaignId;
  final DateTime date;
  final PaymentResponse payment;
  final List<RewardWinningResponse> gainedRewards;

  GiftResponse({
    required this.id,
    required this.campaignId,
    required this.date,
    required this.payment,
    required this.gainedRewards,
  });

  factory GiftResponse.fromJson(Map<String, dynamic> jsonBody) {
    return GiftResponse(
      id: jsonBody['id'] as int,
      campaignId: jsonBody['campaignId'] as int,
      date: DateTime.parse(jsonBody['date'].toString()),
      payment: PaymentResponse.fromJson(jsonBody['payment']),
      gainedRewards: (jsonBody['gainedRewards'] as List<dynamic>? ?? [])
          .map((e) => RewardWinningResponse.fromJson(e))
          .toList(),
    );
  }
}
