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

enum _AttendanceFilter { all, needsAttention, goodStanding }

class _AttendanceScreenState extends State<AttendanceScreen> {
  String _query = '';
  int? _semester;
  _AttendanceFilter _filter = _AttendanceFilter.all;

  List<AttendanceRecord> get _filteredRecords {
    final query = _query.trim().toLowerCase();
    return mockAttendance.where((record) {
      final matchesSearch = query.isEmpty ||
          record.subjectName.toLowerCase().contains(query) ||
          record.courseCode.toLowerCase().contains(query);
      final matchesSemester = _semester == null || record.semester == _semester;

      final pct = attendancePercentage(record.attended, record.total);
      final matchesFilter = switch (_filter) {
        _AttendanceFilter.all => true,
        _AttendanceFilter.needsAttention => pct < 50.0,
        _AttendanceFilter.goodStanding => pct >= 75.0,
      };

      return matchesSearch && matchesSemester && matchesFilter;
    }).toList();
  }

  void _resetFilters() {
    setState(() {
      _query = '';
      _semester = null;
      _filter = _AttendanceFilter.all;
    });
  }

  @override
  Widget build(BuildContext context) {
    final records = _filteredRecords;
    final overall = overallAttendancePercentage(records);
    final attended = records.fold(0, (sum, record) => sum + record.attended);
    final total = records.fold(0, (sum, record) => sum + record.total);

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      children: [
        const SectionHeader(
          title: 'Class Attendance',
          subtitle: 'BS Software Engineering (Semester 3, Section A).',
          badgeText: 'Stage 1 Class',
        ),
        const SizedBox(height: 14),

        // Overall Attendance Card
        _OverallAttendanceCard(
          percentage: overall,
          attended: attended,
          total: total,
          subjectCount: records.length,
        ),
        const SizedBox(height: 16),

        // Search bar
        AppSearchField(
          hintText: 'Search subject or course code...',
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
                label: Text('All Subjects (${mockAttendance.length})'),
                selected: _filter == _AttendanceFilter.all && _semester == null,
                onSelected: (_) => setState(() {
                  _filter = _AttendanceFilter.all;
                  _semester = null;
                }),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Needs Attention (<50%)'),
                selected: _filter == _AttendanceFilter.needsAttention,
                selectedColor: AppColors.warningSurface,
                side: BorderSide(
                  color: _filter == _AttendanceFilter.needsAttention
                      ? AppColors.warning
                      : AppColors.cardBorder,
                ),
                onSelected: (_) => setState(() {
                  _filter = _filter == _AttendanceFilter.needsAttention
                      ? _AttendanceFilter.all
                      : _AttendanceFilter.needsAttention;
                }),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('On Track (>=75%)'),
                selected: _filter == _AttendanceFilter.goodStanding,
                selectedColor: AppColors.paleGreen,
                onSelected: (_) => setState(() {
                  _filter = _filter == _AttendanceFilter.goodStanding
                      ? _AttendanceFilter.all
                      : _AttendanceFilter.goodStanding;
                }),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Result count header
        Row(
          children: [
            Text(
              '${records.length} subject${records.length == 1 ? '' : 's'} displayed',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondaryText,
                  ),
            ),
            const Spacer(),
            if (_query.isNotEmpty || _semester != null || _filter != _AttendanceFilter.all)
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

        if (records.isEmpty)
          EmptyState(
            icon: Icons.search_off_rounded,
            title: 'No attendance records match',
            message: 'Try adjusting your search query or reset the filter chips.',
            actionLabel: 'Reset filters',
            onAction: _resetFilters,
          )
        else
          for (final record in records) ...[
            _AttendanceCard(
              record: record,
              onTap: () => _showRecordDetails(record),
            ),
            const SizedBox(height: 12),
          ],
      ],
    );
  }

  void _showRecordDetails(AttendanceRecord record) {
    final percentage = attendancePercentage(record.attended, record.total);
    final missed = record.total > record.attended ? record.total - record.attended : 0;
    final neededFor75 = record.classesNeededToReach(75.0);

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
                      record.courseCode,
                      style: const TextStyle(
                        color: AppColors.forestGreenDark,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Section ${record.section} • Sem ${record.semester}',
                    style: const TextStyle(color: AppColors.secondaryText, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                record.subjectName,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryText,
                    ),
              ),
              if (record.teacherName != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.person_outline, size: 14, color: AppColors.secondaryText),
                    const SizedBox(width: 4),
                    Text(
                      record.teacherName!,
                      style: const TextStyle(color: AppColors.secondaryText, fontSize: 13),
                    ),
                    if (record.room != null) ...[
                      const SizedBox(width: 10),
                      const Icon(Icons.room_outlined, size: 14, color: AppColors.secondaryText),
                      const SizedBox(width: 4),
                      Text(
                        record.room!,
                        style: const TextStyle(color: AppColors.secondaryText, fontSize: 13),
                      ),
                    ],
                  ],
                ),
              ],
              const SizedBox(height: 18),
              const Divider(height: 1),
              const SizedBox(height: 16),

              // Breakdown grid
              Row(
                children: [
                  Expanded(
                    child: _DetailStatBox(
                      title: 'Attended',
                      value: '${record.attended}',
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _DetailStatBox(
                      title: 'Conducted',
                      value: '${record.total}',
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _DetailStatBox(
                      title: 'Missed',
                      value: '$missed',
                      color: missed > 5 ? AppColors.caution : AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Progress indicator
              LinearProgressIndicator(
                value: progressValue(percentage),
                minHeight: 10,
                borderRadius: BorderRadius.circular(8),
                color: percentage >= 75 ? AppColors.primaryGreen : AppColors.caution,
                backgroundColor: AppColors.paleGreen,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    '${percentageLabel(percentage)} Attendance Rate',
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                  ),
                  const Spacer(),
                  Text(
                    percentage >= 75 ? 'On Track' : 'Below 75%',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: percentage >= 75 ? AppColors.primaryGreen : AppColors.caution,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Target advisory projection
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: percentage >= 75 ? AppColors.paleGreen : AppColors.warningSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: percentage >= 75 ? AppColors.activeGreen : AppColors.warning,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          percentage >= 75
                              ? Icons.check_circle_outline
                              : Icons.warning_amber_rounded,
                          size: 16,
                          color: percentage >= 75 ? AppColors.primaryGreen : AppColors.warning,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          percentage >= 75 ? 'Target Met (>=75%)' : 'Target Projection Advisory',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                            color: percentage >= 75 ? AppColors.forestGreenDark : AppColors.warning,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      percentage >= 75
                          ? 'Your attendance in ${record.subjectName} currently meets the university minimum requirement for midterm exam eligibility.'
                          : 'You need to attend approximately $neededFor75 consecutive upcoming lectures to achieve the 75% attendance threshold.',
                      style: TextStyle(
                        fontSize: 12,
                        color: percentage >= 75 ? AppColors.forestGreenDark : AppColors.primaryText,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Sample data only — this is not an official university attendance record.',
                style: TextStyle(color: AppColors.secondaryText, fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailStatBox extends StatelessWidget {
  const _DetailStatBox({
    required this.title,
    required this.value,
    required this.color,
  });

  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.secondaryText,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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
    final meetsTarget = percentage >= 75.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.paleGreen,
        border: Border.all(color: AppColors.activeGreen, width: 1.2),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A102A16),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.insights_rounded,
                  color: AppColors.primaryGreen,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Overall Standing',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.forestGreenDark,
                          ),
                    ),
                    Text(
                      meetsTarget ? 'Eligible for Exams (>=75%)' : 'Below 75% Requirement',
                      style: TextStyle(
                        fontSize: 11,
                        color: meetsTarget ? AppColors.forestGreenDark : AppColors.caution,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                percentageLabel(percentage),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: AppColors.forestGreenDark,
                      letterSpacing: -0.5,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progressValue(percentage),
              minHeight: 8,
              color: AppColors.primaryGreen,
              backgroundColor: AppColors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.check_circle, size: 14, color: AppColors.primaryGreen),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '$attended of $total total classes attended across $subjectCount subject${subjectCount == 1 ? '' : 's'}.',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.forestGreenDark,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
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
    final isGood = percentage >= 75;
    final progressColor = needsAttention
        ? AppColors.caution
        : isGood
            ? AppColors.primaryGreen
            : AppColors.warning;

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
                      record.courseCode,
                      style: const TextStyle(
                        color: AppColors.forestGreenDark,
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          record.subjectName,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryText,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Section ${record.section} • Semester ${record.semester}${record.teacherName != null ? ' • ${record.teacherName}' : ''}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.secondaryText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        percentageLabel(percentage),
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          color: progressColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      if (needsAttention)
                        const _StatusTag(
                          label: 'Low (<50%)',
                          color: AppColors.caution,
                          background: AppColors.warningSurface,
                        )
                      else if (isGood)
                        const _StatusTag(
                          label: 'On Track',
                          color: AppColors.primaryGreen,
                          background: AppColors.paleGreen,
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Icon(Icons.check_circle_outline, size: 16, color: progressColor),
                  const SizedBox(width: 4),
                  Text(
                    '${record.attended} attended',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 14),
                  const Icon(Icons.event_available_outlined, size: 16, color: AppColors.secondaryText),
                  const SizedBox(width: 4),
                  Text(
                    '${record.total} conducted',
                    style: const TextStyle(fontSize: 12, color: AppColors.secondaryText),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.secondaryText),
                ],
              ),
              const SizedBox(height: 10),
              Semantics(
                label: '${percentageLabel(percentage)} attendance progress',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progressValue(percentage),
                    color: progressColor,
                    backgroundColor: AppColors.paleGreen,
                    minHeight: 7,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusTag extends StatelessWidget {
  const _StatusTag({
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
