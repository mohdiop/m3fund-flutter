import 'package:m3fund_flutter/models/requests/create_payment_request.dart';

class CreateGiftRequest {
  CreatePaymentRequest payment;

  CreateGiftRequest({required this.payment});

  Map<String, dynamic> toMap() {
    return {"payment": payment.toMap()};
  }
}
