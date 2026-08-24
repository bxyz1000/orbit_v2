import 'package:isar_community/isar.dart';

part 'user_preferences.g.dart';

@collection
class UserPreferences {
  Id id = 0; // Fixed ID for single preferences object

  late String userName;
  late String userTagline;
  late String themeMode; // 'system', 'light', 'dark'
  late bool notificationsEnabled;
  late bool aiAssistantEnabled;
  late bool plannerSyncEnabled;
  late String language;

  /// Daily step goal used by the Steps page. Defaults to 10,000 for legacy
  /// records created before this field existed.
  int stepGoal = 10000;

  UserPreferences();

  UserPreferences.defaultValues() {
    userName = 'Bhavik';
    userTagline = 'AI Productivity Enthusiast';
    themeMode = 'system';
    notificationsEnabled = true;
    aiAssistantEnabled = true;
    plannerSyncEnabled = false;
    language = 'English';
    stepGoal = 10000;
  }

  UserPreferences copyWith({
    String? userName,
    String? userTagline,
    String? themeMode,
    bool? notificationsEnabled,
    bool? aiAssistantEnabled,
    bool? plannerSyncEnabled,
    String? language,
    int? stepGoal,
  }) {
    final prefs = UserPreferences()
      ..id = id
      ..userName = userName ?? this.userName
      ..userTagline = userTagline ?? this.userTagline
      ..themeMode = themeMode ?? this.themeMode
      ..notificationsEnabled = notificationsEnabled ?? this.notificationsEnabled
      ..aiAssistantEnabled = aiAssistantEnabled ?? this.aiAssistantEnabled
      ..plannerSyncEnabled = plannerSyncEnabled ?? this.plannerSyncEnabled
      ..language = language ?? this.language
      ..stepGoal = stepGoal ?? this.stepGoal;
    return prefs;
  }
}
