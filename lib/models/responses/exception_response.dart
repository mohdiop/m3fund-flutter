class ExceptionResponse {
  final String code;
  final String message;
  final DateTime timestamp;

  ExceptionResponse({
    required this.code,
    required this.message,
    required this.timestamp,
  });

  factory ExceptionResponse.fromJson(Map<String, dynamic> jsonBody) {
    return ExceptionResponse(
      code: jsonBody['code'] ?? 'UNKNOWN_ERROR',
      message: jsonBody['message'] ?? 'Une erreur inconnue est survenue.',
      timestamp:
          DateTime.tryParse(jsonBody['timestamp'].toString()) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
