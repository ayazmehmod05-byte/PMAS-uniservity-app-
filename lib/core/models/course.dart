class Course {
  const Course({
    required this.code,
    required this.name,
    required this.teacher,
    required this.creditHours,
    required this.section,
    required this.semester,
    required this.session,
    required this.status,
  });

  final String code;
  final String name;
  final String teacher;
  final int creditHours;
  final String section;
  final int semester;
  final String session;
  final String status;
}
