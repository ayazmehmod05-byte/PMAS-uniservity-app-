import 'package:flutter/material.dart';

import '../../app/app_colors.dart';
import '../../app/app_design_tokens.dart';
import '../../app/app_routes.dart';
import '../../core/data/mock_data.dart';
import '../../core/models/attendance_record.dart';
import '../../core/models/class_announcement.dart';
import '../../core/utils/academic_calculations.dart';
import '../../shared/widgets/class_schedule_card.dart';
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

  void _showWeeklyTimetable(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BSSE-3A Class Routine',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryText,
                    ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Fall 2026 • University Institute of Information Technology (UIIT)',
                style: TextStyle(color: AppColors.secondaryText, fontSize: 12),
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 12),
              _buildDayScheduleRow(
                day: 'Monday & Wednesday',
                classes: [
                  '09:00 - 10:30 AM: Info Security (CSC-202) • Room 102',
                  '11:30 - 01:00 PM: Computer Networks (CSC-204) • CS Lab 2',
                ],
              ),
              const SizedBox(height: 12),
              _buildDayScheduleRow(
                day: 'Tuesday & Thursday',
                classes: [
                  '09:00 - 10:30 AM: Software Engineering (CSC-205) • Room 105',
                  '10:45 - 12:15 PM: Data Structures (CSC-203) • CS Lab 1',
                ],
              ),
              const SizedBox(height: 12),
              _buildDayScheduleRow(
                day: 'Friday',
                classes: [
                  '08:30 - 11:30 AM: Probability & Statistics (MTH-220) • Room 204',
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSubtle,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: const Text(
                  'Note: Timetable is subject to official department notifications and room availability.',
                  style: TextStyle(color: AppColors.secondaryText, fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildDayScheduleRow({
    required String day,
    required List<String> classes,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.circle, size: 8, color: AppColors.primaryGreen),
            const SizedBox(width: 6),
            Text(
              day,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: classes
                .map(
                  (c) => Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      c,
                      style: const TextStyle(fontSize: 12, color: AppColors.secondaryText),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  void _showAnnouncementDialog(BuildContext context, ClassAnnouncement ann) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.paleGreen,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.campaign, color: AppColors.primaryGreen, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                ann.title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  ann.author,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const Spacer(),
                Text(
                  ann.timeAgo,
                  style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Text(
              ann.message,
              style: const TextStyle(fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surfaceSubtle,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Class announcement for BS Software Engineering (Semester 3, Section A).',
                style: TextStyle(color: AppColors.secondaryText, fontSize: 11),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        // 1. Hero Class Welcome Banner
        const _HeroClassCard(),
        const SizedBox(height: 20),

        // 2. Academic Summary Metrics
        const SectionHeader(
          title: 'Academic Snapshot',
          subtitle: 'Semester 3 performance & enrollment overview.',
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 720;
            final isTablet = constraints.maxWidth >= 480;
            final columns = isWide ? 4 : isTablet ? 2 : 2;
            const spacing = 10.0;
            final width = (constraints.maxWidth - ((columns - 1) * spacing)) / columns;

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                SizedBox(
                  width: width,
                  child: SummaryCard(
                    label: 'Enrolled Courses',
                    value: '${mockCourses.where((c) => c.isEnrolled).length}',
                    caption: 'Fall 2026',
                    icon: Icons.menu_book_rounded,
                    tint: AppColors.paleGreen,
                    onTap: () => onSelectDestination(AppRoutes.enrollments),
                  ),
                ),
                SizedBox(
                  width: width,
                  child: SummaryCard(
                    label: 'Semester Credits',
                    value: '${totalCreditHours(mockCourses.where((c) => c.isEnrolled))} Cr',
                    caption: '5 Subjects',
                    icon: Icons.timelapse_rounded,
                    tint: const Color(0xFFF1F5F1),
                    iconColor: AppColors.forestGreenDark,
                    onTap: onShowAcademicRecord,
                  ),
                ),
                SizedBox(
                  width: width,
                  child: SummaryCard(
                    label: 'Overall Attendance',
                    value: percentageLabel(overallDemoAttendance),
                    caption: overallDemoAttendance >= 75 ? 'On Track (>=75%)' : 'Needs Focus',
                    icon: Icons.bar_chart_rounded,
                    tint: AppColors.paleGreen,
                    iconColor: overallDemoAttendance >= 75 ? AppColors.primaryGreen : AppColors.caution,
                    onTap: () => onSelectDestination(AppRoutes.attendance),
                  ),
                ),
                SizedBox(
                  width: width,
                  child: SummaryCard(
                    label: "Today's Schedule",
                    value: '${mockClassSchedule.length} Classes',
                    caption: '1 Completed',
                    icon: Icons.calendar_today_rounded,
                    tint: const Color(0xFFEAF3FF),
                    iconColor: AppColors.info,
                    onTap: () => _showWeeklyTimetable(context),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 24),

        // 3. Today's Class Schedule (Stage 1 Class Focus)
        ClassScheduleCard(
          scheduleItems: mockClassSchedule,
          onViewFullTimetable: () => _showWeeklyTimetable(context),
        ),
        const SizedBox(height: 24),

        // 4. Quick Actions Hub
        const SectionHeader(
          title: 'Quick Actions',
          subtitle: 'Direct shortcuts to student academic services.',
        ),
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
                  child: _QuickActionTile(
                    icon: Icons.fact_check_rounded,
                    title: 'Attendance',
                    subtitle: 'Check class logs & rates',
                    color: AppColors.paleGreen,
                    onTap: () => onSelectDestination(AppRoutes.attendance),
                  ),
                ),
                SizedBox(
                  width: width,
                  child: _QuickActionTile(
                    icon: Icons.auto_stories_rounded,
                    title: 'Enrollments',
                    subtitle: 'Current course roster',
                    color: const Color(0xFFF2F7F2),
                    onTap: () => onSelectDestination(AppRoutes.enrollments),
                  ),
                ),
                SizedBox(
                  width: width,
                  child: _QuickActionTile(
                    icon: Icons.history_edu_rounded,
                    title: 'Academic Record',
                    subtitle: 'GPA & credit history',
                    color: const Color(0xFFF4F6F4),
                    onTap: onShowAcademicRecord,
                  ),
                ),
                SizedBox(
                  width: width,
                  child: _QuickActionTile(
                    icon: Icons.person_outline_rounded,
                    title: 'Student ID',
                    subtitle: 'Profile & registration',
                    color: AppColors.paleGreen,
                    onTap: () => onSelectDestination(AppRoutes.profile),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 24),

        // 5. Attendance Progress Highlights
        SectionHeader(
          title: 'Attendance Standing',
          subtitle: 'Subject-wise breakdown (Target: 75%).',
          actionLabel: 'View All',
          onAction: () => onSelectDestination(AppRoutes.attendance),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: mockAttendance
                  .take(3)
                  .map((record) => _AttendanceHighlightRow(record: record))
                  .toList(),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // 6. Class Notice Board & Announcements
        SectionHeader(
          title: 'Class Notice Board',
          subtitle: 'Updates for BS Software Engineering (Sec A).',
          badgeText: '${mockAnnouncements.length} Notices',
        ),
        const SizedBox(height: 12),
        for (final ann in mockAnnouncements) ...[
          _ClassAnnouncementCard(
            announcement: ann,
            onTap: () => _showAnnouncementDialog(context, ann),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _HeroClassCard extends StatelessWidget {
  const _HeroClassCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.paleGreen,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.activeGreen.withValues(alpha: 0.8), width: 1.2),
        boxShadow: AppShadows.card,
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar with online/active indicator
              Stack(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.white,
                    child: Text(
                      MockStudentProfile.initials,
                      style: TextStyle(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Welcome back,',
                          style: TextStyle(
                            color: AppColors.secondaryText,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.white.withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.activeGreen),
                          ),
                          child: const Text(
                            'Demo Portal',
                            style: TextStyle(
                              color: AppColors.forestGreenDark,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      MockStudentProfile.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.4,
                            color: AppColors.primaryText,
                          ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      '${MockStudentProfile.degree} • ${MockStudentProfile.semester}',
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: AppColors.activeGreen),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 14, color: AppColors.forestGreenDark),
              const SizedBox(width: 4),
              const Expanded(
                child: Text(
                  'UIIT • Section A (Morning) • Fall 2026',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.forestGreenDark,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Regular',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
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

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$title, $subtitle',
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.activeGreen.withValues(alpha: 0.5)),
                  ),
                  child: Icon(icon, color: AppColors.primaryGreen, size: 22),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                          color: AppColors.primaryText,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AttendanceHighlightRow extends StatelessWidget {
  const _AttendanceHighlightRow({required this.record});

  final AttendanceRecord record;

  @override
  Widget build(BuildContext context) {
    final percentage = attendancePercentage(record.attended, record.total);
    final isCritical = percentage < 50;
    final isGood = percentage >= 75;
    final progressColor = isCritical
        ? AppColors.caution
        : isGood
            ? AppColors.primaryGreen
            : AppColors.warning;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.paleGreen,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  record.courseCode,
                  style: const TextStyle(
                    color: AppColors.forestGreenDark,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  record.subjectName,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                percentageLabel(percentage),
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                  color: progressColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progressValue(percentage),
              minHeight: 6,
              color: progressColor,
              backgroundColor: AppColors.paleGreen,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                '${record.attended} attended / ${record.total} classes',
                style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
              ),
              const Spacer(),
              if (isCritical)
                const Text(
                  'Needs attention (<50%)',
                  style: TextStyle(fontSize: 10, color: AppColors.caution, fontWeight: FontWeight.w700),
                )
              else if (isGood)
                const Text(
                  'On track (>=75%)',
                  style: TextStyle(fontSize: 10, color: AppColors.primaryGreen, fontWeight: FontWeight.w700),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ClassAnnouncementCard extends StatelessWidget {
  const _ClassAnnouncementCard({
    required this.announcement,
    required this.onTap,
  });

  final ClassAnnouncement announcement;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: announcement.isPinned ? AppColors.paleGreen : AppColors.surfaceSubtle,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: announcement.isPinned ? AppColors.activeGreen : AppColors.cardBorder,
                  ),
                ),
                child: Icon(
                  announcement.isPinned ? Icons.push_pin_rounded : Icons.announcement_outlined,
                  size: 18,
                  color: announcement.isPinned ? AppColors.primaryGreen : AppColors.secondaryText,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSubtle,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppColors.cardBorder),
                          ),
                          child: Text(
                            announcement.category,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          announcement.timeAgo,
                          style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      announcement.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      announcement.message,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.secondaryText,
                        height: 1.35,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
