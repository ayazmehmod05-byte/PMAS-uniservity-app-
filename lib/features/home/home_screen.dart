import 'package:flutter/material.dart';

import '../../app/app_colors.dart';
import '../../app/app_routes.dart';
import '../../core/data/mock_data.dart';
import '../../core/models/attendance_record.dart';
import '../../core/utils/academic_calculations.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/summary_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.onSelectDestination,
    required this.onShowAcademicRecord,
    super.key,
  });

  final ValueChanged<int> onSelectDestination;
  final VoidCallback onShowAcademicRecord;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      children: [
        const _WelcomeCard(),
        const SizedBox(height: 28),
        const SectionHeader(
          title: 'Academic summary',
          subtitle: 'A snapshot of your fictional sample record.',
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 840
                ? 3
                : constraints.maxWidth >= 480
                    ? 2
                    : 1;
            final width =
                (constraints.maxWidth - ((columns - 1) * 12)) / columns;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: width,
                  child: SummaryCard(
                    label: 'Courses',
                    value: '${mockCourses.length}',
                    icon: Icons.menu_book_outlined,
                  ),
                ),
                SizedBox(
                  width: width,
                  child: SummaryCard(
                    label: 'Credit hours',
                    value: '${totalCreditHours(mockCourses)}',
                    icon: Icons.timelapse_outlined,
                    tint: const Color(0xFFF0F2F0),
                  ),
                ),
                SizedBox(
                  width: width,
                  child: SummaryCard(
                    label: 'Overall attendance',
                    value: percentageLabel(overallDemoAttendance),
                    icon: Icons.bar_chart_rounded,
                    tint: const Color(0xFFEAF3FF),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 28),
        const SectionHeader(title: 'Quick actions'),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = (constraints.maxWidth - 12) / 2;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: width,
                  child: _QuickAction(
                    icon: Icons.fact_check_outlined,
                    label: 'Attendance',
                    onTap: () => onSelectDestination(AppRoutes.attendance),
                  ),
                ),
                SizedBox(
                  width: width,
                  child: _QuickAction(
                    icon: Icons.menu_book_outlined,
                    label: 'Enrollments',
                    onTap: () => onSelectDestination(AppRoutes.enrollments),
                  ),
                ),
                SizedBox(
                  width: width,
                  child: _QuickAction(
                    icon: Icons.history_edu_outlined,
                    label: 'Academic record',
                    onTap: onShowAcademicRecord,
                  ),
                ),
                SizedBox(
                  width: width,
                  child: _QuickAction(
                    icon: Icons.person_outline,
                    label: 'My profile',
                    onTap: () => onSelectDestination(AppRoutes.profile),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 28),
        SectionHeader(
          title: 'Attendance overview',
          subtitle: 'Local sample figures only.',
          actionLabel: 'View all',
          onAction: () => onSelectDestination(AppRoutes.attendance),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: mockAttendance
                  .take(3)
                  .map((record) => _AttendancePreview(record: record))
                  .toList(),
            ),
          ),
        ),
        const SizedBox(height: 28),
        const SectionHeader(
          title: 'Announcements',
          subtitle: 'Mock updates for this class project.',
        ),
        const SizedBox(height: 12),
        const _AnnouncementCard(
          icon: Icons.campaign_outlined,
          title: 'Sample semester reminder',
          message:
              'Check your locally displayed enrollment and attendance records before class review.',
        ),
        const SizedBox(height: 12),
        const _AnnouncementCard(
          icon: Icons.info_outline,
          title: 'Demo portal notice',
          message:
              'This prototype works offline and does not represent official university notices.',
        ),
      ],
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.paleGreen,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.activeGreen),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Sample Student',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Text(
                  'BS Software Engineering  •  Semester 3',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Sample project',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.white,
            foregroundColor: AppColors.primaryGreen,
            child: Text('SS', style: TextStyle(fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 112),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon, color: AppColors.primaryGreen),
                  Text(
                    label,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AttendancePreview extends StatelessWidget {
  const _AttendancePreview({required this.record});

  final AttendanceRecord record;

  @override
  Widget build(BuildContext context) {
    final percentage = attendancePercentage(record.attended, record.total);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  record.subjectName,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                percentageLabel(percentage),
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            '${record.attended} of ${record.total} classes',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progressValue(percentage),
            minHeight: 7,
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ),
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  const _AnnouncementCard({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primaryGreen),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(message),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
