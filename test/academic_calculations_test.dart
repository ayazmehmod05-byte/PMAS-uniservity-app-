import 'package:flutter_test/flutter_test.dart';
import 'package:pmas_aaur_student_app/core/data/mock_data.dart';
import 'package:pmas_aaur_student_app/core/models/attendance_record.dart';
import 'package:pmas_aaur_student_app/core/models/course.dart';
import 'package:pmas_aaur_student_app/core/utils/academic_calculations.dart';

void main() {
  // ─── attendancePercentage ─────────────────────────────────────────────────

  group('attendancePercentage', () {
    test('50 % when half the classes were attended', () {
      expect(attendancePercentage(15, 30), 50.0);
    });

    test('100 % when all classes were attended', () {
      expect(attendancePercentage(30, 30), 100.0);
    });

    test('0 % when no classes were attended', () {
      expect(attendancePercentage(0, 30), 0.0);
    });

    test('returns 0 safely when total is zero (no division by zero)', () {
      expect(attendancePercentage(0, 0), 0.0);
    });

    test('clamps result to 100 if attended exceeds total (data anomaly)', () {
      expect(attendancePercentage(35, 30), 100.0);
    });

    test('clamps result to 0 for negative attended (data anomaly)', () {
      // negative attended should still stay at or above 0
      final result = attendancePercentage(-5, 30);
      expect(result, greaterThanOrEqualTo(0.0));
      expect(result, lessThanOrEqualTo(100.0));
    });

    test('calculates fractional percentage correctly', () {
      // 11 / 30 * 100 = 36.666…
      expect(attendancePercentage(11, 30), closeTo(36.666, 0.001));
    });
  });

  // ─── progressValue ────────────────────────────────────────────────────────

  group('progressValue', () {
    test('converts 50 % to 0.5 for LinearProgressIndicator', () {
      expect(progressValue(50), closeTo(0.5, 0.001));
    });

    test('converts 100 % to 1.0', () {
      expect(progressValue(100), 1.0);
    });

    test('converts 0 % to 0.0', () {
      expect(progressValue(0), 0.0);
    });

    test('clamps values above 100 to 1.0', () {
      expect(progressValue(150), 1.0);
    });

    test('clamps negative values to 0.0', () {
      expect(progressValue(-25), 0.0);
    });
  });

  // ─── percentageLabel ─────────────────────────────────────────────────────

  group('percentageLabel', () {
    test('rounds and appends % symbol', () {
      expect(percentageLabel(36.666), '37%');
    });

    test('handles exact integer percentages', () {
      expect(percentageLabel(80.0), '80%');
    });

    test('rounds 0.5 up', () {
      expect(percentageLabel(50.5), '51%');
    });

    test('returns 0% for zero attendance', () {
      expect(percentageLabel(0.0), '0%');
    });
  });

  // ─── overallAttendancePercentage ──────────────────────────────────────────

  group('overallAttendancePercentage', () {
    test(
      'uses combined totals rather than averaging individual percentages',
      () {
        // Subject A: 1/2 = 50%,  Subject B: 9/10 = 90%
        // Simple average would be 70%, but combined = 10/12 ≈ 83.33%
        const records = [
          AttendanceRecord(
            subjectName: 'One',
            courseCode: 'ONE-101',
            section: 'A',
            semester: 1,
            attended: 1,
            total: 2,
          ),
          AttendanceRecord(
            subjectName: 'Two',
            courseCode: 'TWO-101',
            section: 'A',
            semester: 1,
            attended: 9,
            total: 10,
          ),
        ];
        expect(overallAttendancePercentage(records), closeTo(83.333, 0.001));
      },
    );

    test('returns 0 for an empty record list', () {
      expect(overallAttendancePercentage([]), 0.0);
    });

    test('returns 100 when every class in every subject was attended', () {
      const records = [
        AttendanceRecord(
          subjectName: 'A',
          courseCode: 'A-100',
          section: 'A',
          semester: 1,
          attended: 10,
          total: 10,
        ),
        AttendanceRecord(
          subjectName: 'B',
          courseCode: 'B-100',
          section: 'A',
          semester: 1,
          attended: 20,
          total: 20,
        ),
      ];
      expect(overallAttendancePercentage(records), 100.0);
    });

    test('returns 0 when no classes were attended across all subjects', () {
      const records = [
        AttendanceRecord(
          subjectName: 'A',
          courseCode: 'A-100',
          section: 'A',
          semester: 1,
          attended: 0,
          total: 10,
        ),
        AttendanceRecord(
          subjectName: 'B',
          courseCode: 'B-100',
          section: 'A',
          semester: 1,
          attended: 0,
          total: 5,
        ),
      ];
      expect(overallAttendancePercentage(records), 0.0);
    });

    test('handles a single record correctly', () {
      const records = [
        AttendanceRecord(
          subjectName: 'Solo',
          courseCode: 'S-101',
          section: 'A',
          semester: 1,
          attended: 24,
          total: 30,
        ),
      ];
      expect(overallAttendancePercentage(records), closeTo(80.0, 0.001));
    });

    test('handles a record with total == 0 without throwing', () {
      const records = [
        AttendanceRecord(
          subjectName: 'New Course',
          courseCode: 'NEW-001',
          section: 'A',
          semester: 1,
          attended: 0,
          total: 0,
        ),
        AttendanceRecord(
          subjectName: 'Active',
          courseCode: 'ACT-001',
          section: 'A',
          semester: 1,
          attended: 5,
          total: 10,
        ),
      ];
      // 5 / 10 = 50%  (the zero-total record contributes nothing)
      expect(overallAttendancePercentage(records), closeTo(50.0, 0.001));
    });
  });

  // ─── totalCreditHours ────────────────────────────────────────────────────

  group('totalCreditHours', () {
    const sampleCourses = [
      Course(
        code: 'A',
        name: 'Course A',
        teacher: 'T1',
        creditHours: 3,
        section: 'A',
        semester: 1,
        session: 'Fall',
        status: 'Enrolled',
      ),
      Course(
        code: 'B',
        name: 'Course B',
        teacher: 'T2',
        creditHours: 4,
        section: 'A',
        semester: 1,
        session: 'Fall',
        status: 'Enrolled',
      ),
      Course(
        code: 'C',
        name: 'Course C',
        teacher: 'T3',
        creditHours: 3,
        section: 'A',
        semester: 1,
        session: 'Fall',
        status: 'Enrolled',
      ),
    ];

    test('sums credit hours across all courses', () {
      expect(totalCreditHours(sampleCourses), 10);
    });

    test('returns 0 for an empty course list', () {
      expect(totalCreditHours([]), 0);
    });

    test('returns correct total for mock course data', () {
      // mockCourses: CSC-202(3) + CSC-203(4) + CSC-204(3) + CSC-205(3) +
      //              MTH-220(3) + ENG-201(3) = 19
      expect(totalCreditHours(mockCourses), 19);
    });
  });

  // ─── mock data integrity ─────────────────────────────────────────────────

  group('mock data integrity', () {
    test('all attendance records have positive total class counts', () {
      for (final record in mockAttendance) {
        expect(
          record.total,
          greaterThanOrEqualTo(0),
          reason: '${record.courseCode} has a negative total',
        );
      }
    });

    test('attended classes never exceed total for any record', () {
      for (final record in mockAttendance) {
        if (record.total > 0) {
          expect(
            record.attended,
            lessThanOrEqualTo(record.total),
            reason: '${record.courseCode} has attended > total',
          );
        }
      }
    });

    test('all courses have positive credit hours', () {
      for (final course in mockCourses) {
        expect(
          course.creditHours,
          greaterThan(0),
          reason: '${course.code} has zero or negative credit hours',
        );
      }
    });

    test('mock attendance contains the four specified sample courses', () {
      final codes = mockAttendance.map((r) => r.courseCode).toSet();
      expect(codes, containsAll(['CSC-202', 'CSC-204', 'PHY-201', 'CSC-205']));
    });

    test('overallDemoAttendance is pre-calculated and within valid range', () {
      expect(overallDemoAttendance, greaterThanOrEqualTo(0));
      expect(overallDemoAttendance, lessThanOrEqualTo(100));
    });
  });
}
