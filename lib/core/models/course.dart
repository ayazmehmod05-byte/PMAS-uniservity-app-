/// Immutable representation of an enrolled academic course.
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
    this.type = 'Theory',
    this.schedule,
    this.room,
  });

  final String code;
  final String name;
  final String teacher;
  final int creditHours;
  final String section;
  final int semester;
  final String session;
  final String status;
  final String type;
  final String? schedule;
  final String? room;

  bool get isCompleted => status.toLowerCase() == 'completed';
  bool get isEnrolled => status.toLowerCase() == 'enrolled';
}
