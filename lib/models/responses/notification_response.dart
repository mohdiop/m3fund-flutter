import 'package:m3fund_flutter/models/enums/enums.dart';

class NotificationResponse {
  final int id;
  final String title;
  final String content;
  final String senderName;
  final DateTime sentAt;
  final bool isRead;
  final NotificationType type;

  NotificationResponse({
    required this.id,
    required this.title,
    required this.content,
    required this.senderName,
    required this.sentAt,
    required this.isRead,
    required this.type,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> jsonBody) {
    return NotificationResponse(
      id: jsonBody['id'] as int,
      title: jsonBody['title'] ?? '',
      content: jsonBody['content'] ?? '',
      senderName: jsonBody['senderName'] ?? '',
      sentAt: DateTime.parse(jsonBody['sentAt'].toString()),
      isRead: jsonBody['isRead'] ?? false,
      type: _notificationTypeFromString(jsonBody['type']),
    );
  }

  static NotificationType _notificationTypeFromString(String? type) {
    switch (type?.toUpperCase()) {
      case 'NEW_MESSAGE':
        return NotificationType.newMessage;
      case 'NEW_CONTRIBUTION':
        return NotificationType.newContribution;
      case 'NEW_COMMENT':
        return NotificationType.newComment;
      case 'PROJECT_VALIDATED':
        return NotificationType.projectValidated;
      case 'PROJECT_REJECTED':
        return NotificationType.projectRejected;
      case 'TARGET_BUDGET_REACHED':
        return NotificationType.targetBudgetReached;
      case 'CAMPAIGN_FINISHED':
        return NotificationType.campaignFinished;
      case 'SYSTEM_ALERT':
        return NotificationType.systemAlert;
      default:
        throw Exception("Type de notification inconnu: $type");
    }
  }
}
