/// Immutable representation of an attendance record for a course.
class AttendanceRecord {
  const AttendanceRecord({
    required this.subjectName,
    required this.courseCode,
    required this.section,
    required this.semester,
    required this.attended,
    required this.total,
    this.teacherName,
    this.creditHours,
    this.room,
  });

  final String subjectName;
  final String courseCode;
  final String section;
  final int semester;
  final int attended;
  final int total;
  final String? teacherName;
  final int? creditHours;
  final String? room;

  /// Percentage attended (0.0 to 100.0) safely clamped.
  double get percentage =>
      total <= 0 ? 0.0 : (attended / total * 100).clamp(0, 100).toDouble();

  /// Number of missed classes.
  int get missedClasses => total > attended ? total - attended : 0;

  /// True if attendance falls below the low-attendance warning threshold (50%).
  bool get isCritical => percentage < 50.0;

  /// True if student meets or exceeds the university general target (75%).
  bool get meetsUniversityTarget => percentage >= 75.0;

  /// Calculates how many consecutive upcoming classes the student must attend
  /// to reach the target percentage (defaults to 75%).
  int classesNeededToReach(double targetPercentage) {
    if (percentage >= targetPercentage || targetPercentage >= 100.0) return 0;
    final targetFraction = targetPercentage / 100.0;
    // Solve: (attended + x) / (total + x) >= targetFraction
    // attended + x >= targetFraction * total + targetFraction * x
    // x * (1 - targetFraction) >= targetFraction * total - attended
    final numerator = (targetFraction * total) - attended;
    final denominator = 1.0 - targetFraction;
    if (denominator <= 0) return 0;
    final needed = (numerator / denominator).ceil();
    return needed > 0 ? needed : 0;
  }
}
