import '../entities/health_snapshot.dart';

class HealthScoreCalculator {
  static int calculateScore(HealthSnapshot snapshot) {
    int score = 0;

    // Steps
    if (snapshot.steps >= 10000) {
      score += 15;
    } else if (snapshot.steps >= 5000) {
      score += 8;
    } else if (snapshot.steps >= 2500) {
      score += 4;
    }

    // Workout / Active Minutes
    if (snapshot.workoutMinutes >= 30 || snapshot.activeMinutes >= 45) {
      score += 20;
    } else if (snapshot.workoutMinutes >= 15 || snapshot.activeMinutes >= 20) {
      score += 10;
    }

    // Sleep
    const sleepGoalMins = 8 * 60; // 8 hours
    final sleepDiff = (snapshot.sleepMinutes - sleepGoalMins).abs();
    if (snapshot.sleepMinutes > 0) {
      if (sleepDiff <= 60) {
        score += 15; // Within 1 hour of goal
      } else if (sleepDiff <= 120) {
        score += 8;
      }
    }

    return score;
  }
}
