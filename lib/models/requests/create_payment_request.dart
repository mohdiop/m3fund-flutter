import 'package:m3fund_flutter/models/enums/enums.dart';

class CreatePaymentRequest {
  final String transactionId;
  final PaymentType type;
  final PaymentState state;
  final double amount;

  CreatePaymentRequest({
    required this.transactionId,
    required this.type,
    required this.state,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return {
      'transactionId': transactionId,
      'type': _mapPaymentTypeToBackend(type),
      'state': _mapPaymentStateToBackend(state),
      'amount': amount,
    };
  }

  static String _mapPaymentTypeToBackend(PaymentType type) {
    switch (type) {
      case PaymentType.orangeMoney:
        return 'ORANGE_MONEY';
      case PaymentType.moovMoney:
        return 'MOOV_MONEY';
      case PaymentType.paypal:
        return 'PAYPAL';
      case PaymentType.bankCard:
        return 'BANK_CARD';
    }
  }

  static String _mapPaymentStateToBackend(PaymentState state) {
    switch (state) {
      case PaymentState.pending:
        return 'PENDING';
      case PaymentState.success:
        return 'SUCCESS';
      case PaymentState.failed:
        return 'FAILED';
    }
  }
}
