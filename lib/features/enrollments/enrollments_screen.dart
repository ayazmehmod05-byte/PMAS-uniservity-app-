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

class _EnrollmentsScreenState extends State<EnrollmentsScreen> {
  String _query = '';
  int? _semester;

  List<Course> get _filteredCourses {
    final query = _query.trim().toLowerCase();
    return mockCourses.where((course) {
      final matchesSearch = query.isEmpty ||
          course.name.toLowerCase().contains(query) ||
          course.code.toLowerCase().contains(query);
      final matchesSemester = _semester == null || course.semester == _semester;
      return matchesSearch && matchesSemester;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final courses = _filteredCourses;
    final semesters =
        mockCourses.map((course) => course.semester).toSet().toList()..sort();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Enrollments',
            subtitle: 'Fictional local courses for this sample project.',
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final useRow = constraints.maxWidth >= 650;
              final search = AppSearchField(
                hintText: 'Search course name or code',
                onChanged: (value) => setState(() => _query = value),
              );
              final filter = DropdownButtonFormField<int?>(
                initialValue: _semester,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.filter_list_outlined),
                  labelText: 'Semester',
                ),
                items: [
                  const DropdownMenuItem<int?>(
                    value: null,
                    child: Text('All semesters'),
                  ),
                  ...semesters.map(
                    (semester) => DropdownMenuItem<int?>(
                      value: semester,
                      child: Text('Semester $semester'),
                    ),
                  ),
                ],
                onChanged: (value) => setState(() => _semester = value),
              );
              if (useRow) {
                return Row(
                  children: [
                    Expanded(flex: 3, child: search),
                    const SizedBox(width: 12),
                    Expanded(flex: 2, child: filter),
                  ],
                );
              }
              return Column(
                children: [search, const SizedBox(height: 12), filter],
              );
            },
          ),
          const SizedBox(height: 16),
          _EnrollmentSummary(
            courseCount: courses.length,
            creditHours: totalCreditHours(courses),
          ),
          const SizedBox(height: 20),
          Text(
            '${courses.length} course${courses.length == 1 ? '' : 's'} displayed',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: courses.isEmpty
                ? const EmptyState(
                    icon: Icons.menu_book_outlined,
                    title: 'No courses found',
                    message: 'Try a different search term or semester filter.',
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth >= 850) {
                        return _EnrollmentTable(courses: courses);
                      }
                      return ListView.separated(
                        itemCount: courses.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) =>
                            _CourseCard(course: courses[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
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
          const Icon(
            Icons.auto_stories_outlined,
            color: AppColors.primaryGreen,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$courseCount course${courseCount == 1 ? '' : 's'}',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          Text(
            '$creditHours credit hours',
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  const _CourseCard({required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.code,
                        style: const TextStyle(
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        course.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                _StatusChip(status: course.status),
              ],
            ),
            const SizedBox(height: 14),
            _InfoLine(
              icon: Icons.person_outline,
              label: 'Teacher',
              value: course.teacher,
            ),
            const SizedBox(height: 8),
            _InfoLine(
              icon: Icons.school_outlined,
              label: 'Section',
              value: '${course.section}  •  Semester ${course.semester}',
            ),
            const SizedBox(height: 8),
            _InfoLine(
              icon: Icons.calendar_month_outlined,
              label: 'Session',
              value: course.session,
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${course.creditHours} credit hours',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({
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
        Icon(icon, size: 18, color: AppColors.secondaryText),
        const SizedBox(width: 8),
        Expanded(child: Text('$label  $value')),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.paleGreen,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: AppColors.primaryText,
          fontSize: 12,
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
            DataColumn(label: Text('Course')),
            DataColumn(label: Text('Teacher')),
            DataColumn(label: Text('Credit hours'), numeric: true),
            DataColumn(label: Text('Section')),
            DataColumn(label: Text('Semester'), numeric: true),
            DataColumn(label: Text('Session')),
            DataColumn(label: Text('Status')),
          ],
          rows: courses
              .map(
                (course) => DataRow(
                  cells: [
                    DataCell(
                      SizedBox(
                        width: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course.code,
                              style: const TextStyle(
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(course.name, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: 150,
                        child: Text(
                          course.teacher,
                          overflow: TextOverflow.ellipsis,
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
