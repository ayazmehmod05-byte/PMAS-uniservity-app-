import 'package:flutter/material.dart';

import '../../app/app_colors.dart';
import '../../core/data/mock_data.dart';
import '../../core/models/attendance_record.dart';
import '../../core/utils/academic_calculations.dart';
import '../../shared/widgets/app_search_field.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/section_header.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  String _query = '';
  int? _semester;

  List<AttendanceRecord> get _filteredRecords {
    final query = _query.trim().toLowerCase();
    return mockAttendance.where((record) {
      final matchesSearch = query.isEmpty ||
          record.subjectName.toLowerCase().contains(query) ||
          record.courseCode.toLowerCase().contains(query);
      final matchesSemester = _semester == null || record.semester == _semester;
      return matchesSearch && matchesSemester;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final records = _filteredRecords;
    final overall = overallAttendancePercentage(records);
    final attended = records.fold(0, (sum, record) => sum + record.attended);
    final total = records.fold(0, (sum, record) => sum + record.total);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Attendance',
            subtitle: 'All figures below are fictional demo data.',
          ),
          const SizedBox(height: 16),
          AppSearchField(
            hintText: 'Search subject or course code',
            onChanged: (value) => setState(() => _query = value),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int?>(
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
              ...{for (final record in mockAttendance) record.semester}.map(
                (semester) => DropdownMenuItem<int?>(
                  value: semester,
                  child: Text('Semester $semester'),
                ),
              ),
            ],
            onChanged: (value) => setState(() => _semester = value),
          ),
          const SizedBox(height: 16),
          _OverallAttendanceCard(
            percentage: overall,
            attended: attended,
            total: total,
            subjectCount: records.length,
          ),
          const SizedBox(height: 20),
          Text(
            '${records.length} subject${records.length == 1 ? '' : 's'}',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: records.isEmpty
                ? const EmptyState(
                    icon: Icons.search_off_outlined,
                    title: 'No subjects found',
                    message: 'Try another search term or select all semesters.',
                  )
                : ListView.separated(
                    itemCount: records.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) => _AttendanceCard(
                      record: records[index],
                      onTap: () => _showRecordDetails(records[index]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _showRecordDetails(AttendanceRecord record) {
    final percentage = attendancePercentage(record.attended, record.total);
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                record.subjectName,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                '${record.courseCode}  •  Section ${record.section}  •  Semester ${record.semester}',
              ),
              const SizedBox(height: 20),
              Text(
                '${record.attended} attended out of ${record.total} classes',
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progressValue(percentage),
                minHeight: 9,
                borderRadius: BorderRadius.circular(8),
              ),
              const SizedBox(height: 8),
              Text(
                '${percentageLabel(percentage)} attendance',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              const Text(
                'Sample data only — this is not an official attendance record.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OverallAttendanceCard extends StatelessWidget {
  const _OverallAttendanceCard({
    required this.percentage,
    required this.attended,
    required this.total,
    required this.subjectCount,
  });

  final double percentage;
  final int attended;
  final int total;
  final int subjectCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.paleGreen,
        border: Border.all(color: AppColors.activeGreen),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.insights_outlined,
                color: AppColors.primaryGreen,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Overall attendance',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
              Text(
                percentageLabel(percentage),
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w900),
              ),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: progressValue(percentage),
            minHeight: 8,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 8),
          Text(
            '$attended of $total classes across $subjectCount displayed subject${subjectCount == 1 ? '' : 's'}.',
          ),
        ],
      ),
    );
  }
}

class _AttendanceCard extends StatelessWidget {
  const _AttendanceCard({required this.record, required this.onTap});

  final AttendanceRecord record;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final percentage = attendancePercentage(record.attended, record.total);
    final needsAttention = percentage < 50;
    final progressColor =
        needsAttention ? AppColors.warning : AppColors.primaryGreen;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
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
                          record.subjectName,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${record.courseCode}  •  Section ${record.section}  •  Semester ${record.semester}',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    percentageLabel(percentage),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 18,
                    color: progressColor,
                  ),
                  const SizedBox(width: 6),
                  Text('${record.attended} attended'),
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 17,
                    color: AppColors.secondaryText,
                  ),
                  const SizedBox(width: 6),
                  Text('${record.total} total'),
                  const Spacer(),
                  if (needsAttention) const _AttentionLabel(),
                ],
              ),
              const SizedBox(height: 12),
              Semantics(
                label: '${percentageLabel(percentage)} attendance progress',
                child: LinearProgressIndicator(
                  value: progressValue(percentage),
                  color: progressColor,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AttentionLabel extends StatelessWidget {
  const _AttentionLabel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.warningSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'Needs attention',
        style: TextStyle(
          color: AppColors.warning,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
