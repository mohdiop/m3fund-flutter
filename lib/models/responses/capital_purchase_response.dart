import 'package:m3fund_flutter/models/responses/payment_response.dart';

class CapitalPurchaseResponse {
  final int id;
  final DateTime date;
  final double shareAcquired;
  final int campaignId;
  final int contributorId;
  final bool isValidatedByContributor;
  final bool isValidatedByOwner;
  final PaymentResponse payment;

  CapitalPurchaseResponse({
    required this.id,
    required this.date,
    required this.shareAcquired,
    required this.campaignId,
    required this.contributorId,
    required this.isValidatedByContributor,
    required this.isValidatedByOwner,
    required this.payment,
  });

  factory CapitalPurchaseResponse.fromJson(Map<String, dynamic> json) {
    return CapitalPurchaseResponse(
      id: json['id'] as int,
      date: DateTime.parse(json['date'].toString()),
      shareAcquired: (json['shareAcquired'] as num).toDouble(),
      campaignId: json['campaignId'] as int,
      contributorId: json['contributorId'] as int,
      isValidatedByContributor: json['isValidatedByContributor'] as bool,
      isValidatedByOwner: json['isValidatedByOwner'] as bool,
      payment: PaymentResponse.fromJson(json['payment']),
    );
  }
}
