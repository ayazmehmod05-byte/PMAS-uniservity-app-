class AttendanceRecord {
  const AttendanceRecord({
    required this.subjectName,
    required this.courseCode,
    required this.section,
    required this.semester,
    required this.attended,
    required this.total,
  });

  final String subjectName;
  final String courseCode;
  final String section;
  final int semester;
  final int attended;
  final int total;
}
