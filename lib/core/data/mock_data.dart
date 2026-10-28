import '../models/attendance_record.dart';
import '../models/course.dart';
import '../utils/academic_calculations.dart';

/// Local, fictional records used throughout the demo. They are not live data.
const mockAttendance = <AttendanceRecord>[
  AttendanceRecord(
    subjectName: 'Information Security',
    courseCode: 'CSC-202',
    section: 'A',
    semester: 3,
    attended: 11,
    total: 30,
  ),
  AttendanceRecord(
    subjectName: 'Computer Networks',
    courseCode: 'CSC-204',
    section: 'A',
    semester: 3,
    attended: 15,
    total: 31,
  ),
  AttendanceRecord(
    subjectName: 'Applied Physics',
    courseCode: 'PHY-201',
    section: 'A',
    semester: 3,
    attended: 0,
    total: 2,
  ),
  AttendanceRecord(
    subjectName: 'Software Engineering',
    courseCode: 'CSC-205',
    section: 'A',
    semester: 3,
    attended: 24,
    total: 30,
  ),
];

const mockCourses = <Course>[
  Course(
    code: 'CSC-202',
    name: 'Information Security',
    teacher: 'Sample Instructor A',
    creditHours: 3,
    section: 'A',
    semester: 3,
    session: 'Fall 2026',
    status: 'Enrolled',
  ),
  Course(
    code: 'CSC-203',
    name: 'Data Structures',
    teacher: 'Sample Instructor B',
    creditHours: 4,
    section: 'A',
    semester: 3,
    session: 'Fall 2026',
    status: 'Enrolled',
  ),
  Course(
    code: 'CSC-204',
    name: 'Computer Networks',
    teacher: 'Sample Instructor C',
    creditHours: 3,
    section: 'A',
    semester: 3,
    session: 'Fall 2026',
    status: 'Enrolled',
  ),
  Course(
    code: 'CSC-205',
    name: 'Software Engineering',
    teacher: 'Sample Instructor D',
    creditHours: 3,
    section: 'A',
    semester: 3,
    session: 'Fall 2026',
    status: 'Enrolled',
  ),
  Course(
    code: 'MTH-220',
    name: 'Probability and Statistics',
    teacher: 'Sample Instructor E',
    creditHours: 3,
    section: 'A',
    semester: 3,
    session: 'Fall 2026',
    status: 'Enrolled',
  ),
  Course(
    code: 'ENG-201',
    name: 'Technical Writing',
    teacher: 'Sample Instructor F',
    creditHours: 3,
    section: 'A',
    semester: 2,
    session: 'Spring 2026',
    status: 'Completed',
  ),
];

int totalCreditHours(Iterable<Course> courses) =>
    courses.fold(0, (sum, course) => sum + course.creditHours);

final overallDemoAttendance = overallAttendancePercentage(mockAttendance);
