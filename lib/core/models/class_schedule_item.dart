/// Represents a single lecture or lab session in the class schedule.
class ClassScheduleItem {
  const ClassScheduleItem({
    required this.courseCode,
    required this.subjectName,
    required this.timeSlot,
    required this.room,
    required this.instructor,
    required this.type, // 'Lecture' or 'Lab'
    this.isCompleted = false,
    this.isCurrent = false,
  });

  final String courseCode;
  final String subjectName;
  final String timeSlot;
  final String room;
  final String instructor;
  final String type;
  final bool isCompleted;
  final bool isCurrent;
}
