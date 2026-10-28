import '../models/attendance_record.dart';

/// Returns zero for an invalid or empty total so attendance views stay safe.
double attendancePercentage(int attended, int total) {
  if (total <= 0) {
    return 0;
  }
  return (attended / total * 100).clamp(0, 100).toDouble();
}

/// Uses the totals across records, rather than averaging subject percentages.
double overallAttendancePercentage(Iterable<AttendanceRecord> records) {
  var attended = 0;
  var total = 0;
  for (final record in records) {
    attended += record.attended;
    total += record.total;
  }
  return attendancePercentage(attended, total);
}

String percentageLabel(double percentage) => '${percentage.round()}%';

double progressValue(double percentage) =>
    (percentage / 100).clamp(0, 1).toDouble();
