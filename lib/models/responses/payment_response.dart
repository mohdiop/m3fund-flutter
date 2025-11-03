import 'package:m3fund_flutter/models/enums/enums.dart';

class PaymentResponse {
  final int id;
  final String transactionId;
  final PaymentType type;
  final PaymentState state;
  final DateTime madeAt;
  final double amount;
  final String projectName;

  PaymentResponse({
    required this.id,
    required this.transactionId,
    required this.type,
    required this.state,
    required this.madeAt,
    required this.amount,
    required this.projectName
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> jsonBody) {
    return PaymentResponse(
      id: jsonBody['id'] as int,
      transactionId: jsonBody['transactionId'] ?? '',
      type: _paymentTypeFromString(jsonBody['type']),
      state: _paymentStateFromString(jsonBody['state']),
      madeAt: DateTime.parse(jsonBody['madeAt'].toString()),
      amount: (jsonBody['amount'] as num).toDouble(),
      projectName: jsonBody['projectName'] as String
    );
  }

  static PaymentType _paymentTypeFromString(String? type) {
    switch (type?.toUpperCase()) {
      case 'ORANGE_MONEY':
        return PaymentType.orangeMoney;
      case 'MOOV_MONEY':
        return PaymentType.moovMoney;
      case 'PAYPAL':
        return PaymentType.paypal;
      case 'BANK_CARD':
        return PaymentType.bankCard;
      default:
        throw Exception("Type de paiement inconnu: $type");
    }
  }

  static PaymentState _paymentStateFromString(String? state) {
    switch (state?.toUpperCase()) {
      case 'PENDING':
        return PaymentState.pending;
      case 'SUCCESS':
        return PaymentState.success;
      case 'FAILED':
        return PaymentState.failed;
      default:
        throw Exception("État de paiement inconnu: $state");
    }
  }
}
