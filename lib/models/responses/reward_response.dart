import 'package:m3fund_flutter/models/enums/enums.dart';

class RewardResponse {
  final int id;
  final String name;
  final String description;
  final RewardType type;
  final int quantity;
  final double unlockAmount;

  RewardResponse({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.quantity,
    required this.unlockAmount,
  });

  factory RewardResponse.fromJson(Map<String, dynamic> jsonBody) {
    return RewardResponse(
      id: jsonBody['id'] as int,
      name: jsonBody['name'] ?? '',
      description: jsonBody['description'] ?? '',
      type: _rewardTypeFromString(jsonBody['type']),
      quantity: jsonBody['quantity'] as int,
      unlockAmount: (jsonBody['unlockAmount'] as num).toDouble(),
    );
  }

  static RewardType _rewardTypeFromString(String? type) {
    switch (type?.toUpperCase()) {
      case 'SYMBOLIC':
        return RewardType.symbolic;
      case 'PRODUCT':
        return RewardType.product;
      default:
        throw Exception('Type de récompense inconnu: $type');
    }
  }
}
