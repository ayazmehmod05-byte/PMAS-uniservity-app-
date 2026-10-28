import 'package:flutter/material.dart';

import '../../app/app_colors.dart';
import '../../core/data/mock_data.dart';
import '../../core/models/course.dart';
import '../../shared/widgets/app_search_field.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/section_header.dart';

class EnrollmentsScreen extends StatefulWidget {
  const EnrollmentsScreen({super.key});

  @override
  State<EnrollmentsScreen> createState() => _EnrollmentsScreenState();
}

enum _CourseStatusFilter { all, currentEnrolled, completed }

class _EnrollmentsScreenState extends State<EnrollmentsScreen> {
  String _query = '';
  int? _semester;
  _CourseStatusFilter _statusFilter = _CourseStatusFilter.all;

  List<Course> get _filteredCourses {
    final query = _query.trim().toLowerCase();
    return mockCourses.where((course) {
      final matchesSearch = query.isEmpty ||
          course.name.toLowerCase().contains(query) ||
          course.code.toLowerCase().contains(query) ||
          course.teacher.toLowerCase().contains(query);
      final matchesSemester = _semester == null || course.semester == _semester;
      final matchesStatus = switch (_statusFilter) {
        _CourseStatusFilter.all => true,
        _CourseStatusFilter.currentEnrolled => course.isEnrolled,
        _CourseStatusFilter.completed => course.isCompleted,
      };
      return matchesSearch && matchesSemester && matchesStatus;
    }).toList();
  }

  void _resetFilters() {
    setState(() {
      _query = '';
      _semester = null;
      _statusFilter = _CourseStatusFilter.all;
    });
  }

  void _showCourseDetails(Course course) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.paleGreen,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      course.code,
                      style: const TextStyle(
                        color: AppColors.forestGreenDark,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSubtle,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Text(
                      '${course.creditHours} Credit Hours (${course.type})',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const Spacer(),
                  _StatusChip(status: course.status),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                course.name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryText,
                    ),
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),
              _DetailRow(
                icon: Icons.person_outline_rounded,
                label: 'Course Instructor',
                value: course.teacher,
              ),
              const SizedBox(height: 10),
              _DetailRow(
                icon: Icons.meeting_room_outlined,
                label: 'Assigned Venue',
                value: course.room ?? 'UIIT Department Room',
              ),
              const SizedBox(height: 10),
              _DetailRow(
                icon: Icons.access_time_rounded,
                label: 'Weekly Timetable',
                value: course.schedule ?? 'As per official class timetable',
              ),
              const SizedBox(height: 10),
              _DetailRow(
                icon: Icons.school_outlined,
                label: 'Class Allocation',
                value: 'Section ${course.section} • Semester ${course.semester}',
              ),
              const SizedBox(height: 10),
              _DetailRow(
                icon: Icons.calendar_month_outlined,
                label: 'Academic Session',
                value: course.session,
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSubtle,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: const Text(
                  'Course registration and credits verified for PMAS-AAUR student demo catalog.',
                  style: TextStyle(color: AppColors.secondaryText, fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final courses = _filteredCourses;
    final totalCredits = totalCreditHours(courses);

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      children: [
        const SectionHeader(
          title: 'Course Catalog',
          subtitle: 'Enrolled subjects for BS Software Engineering (Sec A).',
          badgeText: 'Stage 1 Class',
        ),
        const SizedBox(height: 14),

        // Search Bar
        AppSearchField(
          hintText: 'Search course title, code, or teacher...',
          initialText: _query,
          onChanged: (value) => setState(() => _query = value),
        ),
        const SizedBox(height: 12),

        // Quick Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              FilterChip(
                label: Text('All (${mockCourses.length})'),
                selected: _statusFilter == _CourseStatusFilter.all && _semester == null,
                onSelected: (_) => setState(() {
                  _statusFilter = _CourseStatusFilter.all;
                  _semester = null;
                }),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Current Semester 3 (Fall 2026)'),
                selected: _statusFilter == _CourseStatusFilter.currentEnrolled && _semester == 3,
                selectedColor: AppColors.paleGreen,
                onSelected: (_) => setState(() {
                  _statusFilter = _CourseStatusFilter.currentEnrolled;
                  _semester = 3;
                }),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Completed'),
                selected: _statusFilter == _CourseStatusFilter.completed,
                selectedColor: AppColors.surfaceSubtle,
                onSelected: (_) => setState(() {
                  _statusFilter = _statusFilter == _CourseStatusFilter.completed
                      ? _CourseStatusFilter.all
                      : _CourseStatusFilter.completed;
                }),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Credit summary box
        _EnrollmentSummary(
          courseCount: courses.length,
          creditHours: totalCredits,
        ),
        const SizedBox(height: 16),

        // Results count
        Row(
          children: [
            Text(
              '${courses.length} course${courses.length == 1 ? '' : 's'} displayed',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondaryText,
                  ),
            ),
            const Spacer(),
            if (_query.isNotEmpty || _semester != null || _statusFilter != _CourseStatusFilter.all)
              TextButton(
                onPressed: _resetFilters,
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                child: const Text('Reset filters', style: TextStyle(fontSize: 12)),
              ),
          ],
        ),
        const SizedBox(height: 10),

        if (courses.isEmpty)
          EmptyState(
            icon: Icons.menu_book_outlined,
            title: 'No courses found',
            message: 'Try a different search term or reset your semester filter.',
            actionLabel: 'Reset filters',
            onAction: _resetFilters,
          )
        else
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 850) {
                return _EnrollmentTable(courses: courses);
              }
              return Column(
                children: [
                  for (final course in courses) ...[
                    _CourseCard(
                      course: course,
                      onTap: () => _showCourseDetails(course),
                    ),
                    const SizedBox(height: 12),
                  ],
                ],
              );
            },
          ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.primaryGreen),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.secondaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EnrollmentSummary extends StatelessWidget {
  const _EnrollmentSummary({
    required this.courseCount,
    required this.creditHours,
  });

  final int courseCount;
  final int creditHours;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.paleGreen,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.activeGreen),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.auto_stories_rounded,
              color: AppColors.primaryGreen,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$courseCount Course${courseCount == 1 ? '' : 's'} Selected',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: AppColors.forestGreenDark,
                  ),
                ),
                const Text(
                  'Fall 2026 Academic Session',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.forestGreenDark,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.activeGreen),
            ),
            child: Text(
              '$creditHours Cr Hrs',
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 13,
                color: AppColors.forestGreenDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  const _CourseCard({required this.course, required this.onTap});

  final Course course;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.paleGreen,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      course.code,
                      style: const TextStyle(
                        color: AppColors.forestGreenDark,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      course.name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryText,
                          ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _StatusChip(status: course.status),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.person_outline_rounded, size: 16, color: AppColors.secondaryText),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      course.teacher,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.secondaryText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSubtle,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Text(
                      '${course.creditHours} Cr (${course.type})',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryText,
                      ),
                    ),
                  ),
                ],
              ),
              if (course.schedule != null || course.room != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.meeting_room_outlined, size: 15, color: AppColors.secondaryText),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${course.room ?? 'Room TBA'} • ${course.schedule ?? 'Timetable TBA'}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.secondaryText,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.secondaryText),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final isEnrolled = status.toLowerCase() == 'enrolled';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isEnrolled ? AppColors.paleGreen : AppColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isEnrolled ? AppColors.activeGreen : AppColors.cardBorder,
        ),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: isEnrolled ? AppColors.forestGreenDark : AppColors.secondaryText,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _EnrollmentTable extends StatelessWidget {
  const _EnrollmentTable({required this.courses});

  final List<Course> courses;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: const WidgetStatePropertyAll(
            AppColors.tableHeaderGrey,
          ),
          columns: const [
            DataColumn(label: Text('Course', style: TextStyle(fontWeight: FontWeight.w800))),
            DataColumn(label: Text('Teacher', style: TextStyle(fontWeight: FontWeight.w800))),
            DataColumn(label: Text('Credit Hours', style: TextStyle(fontWeight: FontWeight.w800)), numeric: true),
            DataColumn(label: Text('Section', style: TextStyle(fontWeight: FontWeight.w800))),
            DataColumn(label: Text('Semester', style: TextStyle(fontWeight: FontWeight.w800)), numeric: true),
            DataColumn(label: Text('Session', style: TextStyle(fontWeight: FontWeight.w800))),
            DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.w800))),
          ],
          rows: courses
              .map(
                (course) => DataRow(
                  cells: [
                    DataCell(
                      SizedBox(
                        width: 220,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course.code,
                              style: const TextStyle(
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              course.name,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: 160,
                        child: Text(
                          course.teacher,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    DataCell(Text('${course.creditHours}')),
                    DataCell(Text(course.section)),
                    DataCell(Text('${course.semester}')),
                    DataCell(Text(course.session)),
                    DataCell(_StatusChip(status: course.status)),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
