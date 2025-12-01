import 'package:m3fund_flutter/models/requests/create/create_payment_request.dart';

class CreateCapitalPurchaseRequest {
  final double shareAcquired;
  final CreatePaymentRequest payment;

  CreateCapitalPurchaseRequest({
    required this.shareAcquired,
    required this.payment,
  });

  Map<String, dynamic> toMap() {
    return {"shareAcquired": shareAcquired, "payment": payment.toMap()};
  }
}
