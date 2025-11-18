import 'package:shared_preferences/shared_preferences.dart';

class NotificationReadStorage {
  NotificationReadStorage._();

  static final NotificationReadStorage instance = NotificationReadStorage._();
  static const String _storageKey = "read_notification_ids";

  Future<Set<int>> loadReadIds() async {
    final prefs = await SharedPreferences.getInstance();
    final storedIds = prefs.getStringList(_storageKey) ?? [];
    return storedIds.map(int.parse).toSet();
  }

  Future<void> saveReadIds(Set<int> ids) async {
    final prefs = await SharedPreferences.getInstance();
    final serialized = ids.map((id) => id.toString()).toList();
    await prefs.setStringList(_storageKey, serialized);
  }
}

