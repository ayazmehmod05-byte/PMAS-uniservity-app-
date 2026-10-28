import '../models/attendance_record.dart';
import '../models/class_announcement.dart';
import '../models/class_schedule_item.dart';
import '../models/course.dart';
import '../utils/academic_calculations.dart';

/// Local, fictional records used throughout the class prototype.
/// All figures and student details are non-sensitive demo data.
const mockAttendance = <AttendanceRecord>[
  AttendanceRecord(
    subjectName: 'Information Security',
    courseCode: 'CSC-202',
    section: 'A',
    semester: 3,
    attended: 11,
    total: 30,
    teacherName: 'Sample Instructor A',
    creditHours: 3,
    room: 'Room 102',
  ),
  AttendanceRecord(
    subjectName: 'Computer Networks',
    courseCode: 'CSC-204',
    section: 'A',
    semester: 3,
    attended: 15,
    total: 31,
    teacherName: 'Sample Instructor C',
    creditHours: 3,
    room: 'CS Lab 2',
  ),
  AttendanceRecord(
    subjectName: 'Applied Physics',
    courseCode: 'PHY-201',
    section: 'A',
    semester: 3,
    attended: 0,
    total: 2,
    teacherName: 'Sample Instructor F',
    creditHours: 3,
    room: 'Physics Lab',
  ),
  AttendanceRecord(
    subjectName: 'Software Engineering',
    courseCode: 'CSC-205',
    section: 'A',
    semester: 3,
    attended: 24,
    total: 30,
    teacherName: 'Sample Instructor D',
    creditHours: 3,
    room: 'Room 105',
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
    type: 'Theory',
    schedule: 'Mon, Wed 09:00 - 10:30 AM',
    room: 'Room 102',
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
    type: 'Theory + Lab',
    schedule: 'Tue, Thu 10:45 AM - 12:15 PM',
    room: 'CS Lab 1',
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
    type: 'Theory + Lab',
    schedule: 'Mon, Wed 11:30 AM - 01:00 PM',
    room: 'CS Lab 2',
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
    type: 'Theory',
    schedule: 'Tue, Thu 09:00 - 10:30 AM',
    room: 'Room 105',
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
    type: 'Theory',
    schedule: 'Friday 08:30 - 11:30 AM',
    room: 'Room 204',
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
    type: 'Theory',
    schedule: 'Completed (Spring 2026)',
    room: 'Room 101',
  ),
];

/// Sample schedule for the student's class (BS Software Engineering - Semester 3, Section A).
const mockClassSchedule = <ClassScheduleItem>[
  ClassScheduleItem(
    courseCode: 'CSC-202',
    subjectName: 'Information Security',
    timeSlot: '09:00 AM - 10:30 AM',
    room: 'Room 102 (UIIT)',
    instructor: 'Sample Instructor A',
    type: 'Lecture',
    isCompleted: true,
  ),
  ClassScheduleItem(
    courseCode: 'CSC-204',
    subjectName: 'Computer Networks',
    timeSlot: '11:30 AM - 01:00 PM',
    room: 'CS Lab 2',
    instructor: 'Sample Instructor C',
    type: 'Lab',
    isCurrent: true,
  ),
  ClassScheduleItem(
    courseCode: 'CSC-205',
    subjectName: 'Software Engineering',
    timeSlot: '02:00 PM - 03:30 PM',
    room: 'Room 105 (UIIT)',
    instructor: 'Sample Instructor D',
    type: 'Lecture',
  ),
];

/// Sample class announcements.
const mockAnnouncements = <ClassAnnouncement>[
  ClassAnnouncement(
    id: 'ann-1',
    title: 'Computer Networks Lab 3 Submission',
    message:
        'Please submit your packet tracer topology report on Google Classroom before Friday 11:59 PM.',
    category: 'CR Notice',
    author: 'Class Representative (BSSE-3A)',
    timeAgo: '2 hours ago',
    isPinned: true,
  ),
  ClassAnnouncement(
    id: 'ann-2',
    title: 'Midterm Examination Schedule Advisory',
    message:
        'Tentative midterm dates have been posted on the department board. Ensure at least 75% attendance for examination slips.',
    category: 'Academic Notice',
    author: 'Department Coordinator',
    timeAgo: '1 day ago',
  ),
  ClassAnnouncement(
    id: 'ann-3',
    title: 'Software Engineering Guest Lecture',
    message:
        'An interactive seminar on Agile Scrum methodologies will be held this Thursday in the UIIT Seminar Hall.',
    category: 'Class Event',
    author: 'Sample Instructor D',
    timeAgo: '3 days ago',
  ),
];

/// Static mock student profile for BS Software Engineering Semester 3.
abstract final class MockStudentProfile {
  static const name = 'Sample Student';
  static const initials = 'SS';
  static const rollNumber = 'BSSE-3A-012';
  static const registrationId = 'DEMO-SE-2026-001';
  static const degree = 'BS Software Engineering';
  static const department = 'University Institute of Information Technology (UIIT)';
  static const faculty = 'Faculty of Sciences';
  static const semester = 'Semester 3';
  static const section = 'Section A';
  static const session = 'Fall 2026';
  static const batch = '2023 - 2027';
  static const shift = 'Morning';
  static const status = 'Regular (Enrolled)';
  static const email = 'sample.student@arid.edu.pk (Demo)';
  static const campus = 'Main Campus, Rawalpindi';
  static const bloodGroup = 'O+ (Sample)';
}

int totalCreditHours(Iterable<Course> courses) =>
    courses.fold(0, (sum, course) => sum + course.creditHours);

final overallDemoAttendance = overallAttendancePercentage(mockAttendance);
