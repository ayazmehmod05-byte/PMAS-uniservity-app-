import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/data/mock_data.dart';
import '../features/attendance/attendance_screen.dart';
import '../features/enrollments/enrollments_screen.dart';
import '../features/home/home_screen.dart';
import '../features/notifications/notifications_screen.dart';
import '../features/profile/profile_screen.dart';
import '../shared/widgets/university_header.dart';
import 'app_colors.dart';
import 'app_routes.dart';
import 'app_theme.dart';

class StudentPortalApp extends StatelessWidget {
  const StudentPortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PMAS-AAUR Student App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(),
      home: const AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: AppColors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarDividerColor: AppColors.divider,
        ),
        child: AppShell(),
      ),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = AppRoutes.home;

  void _selectDestination(int index) {
    setState(() => _selectedIndex = index);
  }

  void _showAcademicRecord() {
    final currentCourses = mockCourses.where((c) => c.isEnrolled).toList();
    final currentCredits = totalCreditHours(currentCourses);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
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
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.paleGreen,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.history_edu_rounded,
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
                          'Academic Transcript Summary',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryText,
                              ),
                        ),
                        const Text(
                          'BS Software Engineering (2023 - 2027)',
                          style: TextStyle(color: AppColors.secondaryText, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),

              // GPA & Credit Snapshot
              Row(
                children: [
                  const Expanded(
                    child: _RecordStatTile(
                      label: 'Cumulative GPA',
                      value: '3.58',
                      caption: 'Target: >= 2.00',
                      tint: AppColors.paleGreen,
                      textColor: AppColors.forestGreenDark,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: _RecordStatTile(
                      label: 'Completed Credits',
                      value: '35 / 134',
                      caption: '26% of Degree',
                      tint: AppColors.surfaceSubtle,
                      textColor: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _RecordStatTile(
                      label: 'Current Load',
                      value: '$currentCredits Cr',
                      caption: '${currentCourses.length} Subjects',
                      tint: const Color(0xFFEFF6FF),
                      textColor: AppColors.info,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Semester Breakdown List
              Text(
                'Semester Breakdown (Demo Records)',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 8),
              const _SemesterRow(
                semester: 'Semester 1 (Fall 2025)',
                credits: '18 Credit Hours',
                gpa: 'GPA 3.50',
                status: 'Passed',
                isCompleted: true,
              ),
              const SizedBox(height: 6),
              const _SemesterRow(
                semester: 'Semester 2 (Spring 2026)',
                credits: '17 Credit Hours',
                gpa: 'GPA 3.65',
                status: 'Passed',
                isCompleted: true,
              ),
              const SizedBox(height: 6),
              _SemesterRow(
                semester: 'Semester 3 (Fall 2026)',
                credits: '$currentCredits Credit Hours',
                gpa: 'In Progress',
                status: 'Current',
                isCompleted: false,
              ),
              const SizedBox(height: 16),

              // Notice Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSubtle,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: const Text(
                  'Fictional sample transcript for PMAS-AAUR class project demonstration. Official degrees require Controller of Examinations issued transcripts.',
                  style: TextStyle(color: AppColors.secondaryText, fontSize: 11, height: 1.4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openNotifications() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const NotificationsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      HomeScreen(
        onSelectDestination: _selectDestination,
        onShowAcademicRecord: _showAcademicRecord,
      ),
      const AttendanceScreen(),
      const EnrollmentsScreen(),
      const ProfileScreen(),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final useRail = constraints.maxWidth >= 760;
        final content = IndexedStack(index: _selectedIndex, children: pages);

        if (useRail) {
          return Scaffold(
            body: SafeArea(
              child: Row(
                children: [
                  NavigationRail(
                    selectedIndex: _selectedIndex,
                    onDestinationSelected: _selectDestination,
                    labelType: NavigationRailLabelType.all,
                    leading: const Padding(
                      padding: EdgeInsets.fromLTRB(12, 12, 12, 18),
                      child: Icon(
                        Icons.school_rounded,
                        color: AppColors.primaryGreen,
                        size: 28,
                      ),
                    ),
                    destinations: _railDestinations,
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(
                    child: Column(
                      children: [
                        UniversityHeader(
                          onNotificationsPressed: _openNotifications,
                        ),
                        Expanded(child: content),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                UniversityHeader(onNotificationsPressed: _openNotifications),
                Expanded(child: content),
              ],
            ),
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _selectDestination,
            destinations: _barDestinations,
          ),
        );
      },
    );
  }
}

class _RecordStatTile extends StatelessWidget {
  const _RecordStatTile({
    required this.label,
    required this.value,
    required this.caption,
    required this.tint,
    required this.textColor,
  });

  final String label;
  final String value;
  final String caption;
  final Color tint;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: textColor,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryText,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            caption,
            style: TextStyle(
              fontSize: 10,
              color: textColor.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _SemesterRow extends StatelessWidget {
  const _SemesterRow({
    required this.semester,
    required this.credits,
    required this.gpa,
    required this.status,
    required this.isCompleted,
  });

  final String semester;
  final String credits;
  final String gpa;
  final String status;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Icon(
            isCompleted ? Icons.check_circle_rounded : Icons.pending_outlined,
            size: 16,
            color: isCompleted ? AppColors.primaryGreen : AppColors.caution,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  semester,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                ),
                Text(
                  credits,
                  style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                gpa,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  color: isCompleted ? AppColors.primaryGreen : AppColors.caution,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: isCompleted ? AppColors.paleGreen : AppColors.warningSurface,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: isCompleted ? AppColors.forestGreenDark : AppColors.warning,
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

const _barDestinations = <NavigationDestination>[
  NavigationDestination(
    icon: Icon(Icons.home_outlined),
    selectedIcon: Icon(Icons.home_rounded),
    label: 'Home',
  ),
  NavigationDestination(
    icon: Icon(Icons.fact_check_outlined),
    selectedIcon: Icon(Icons.fact_check_rounded),
    label: 'Attendance',
  ),
  NavigationDestination(
    icon: Icon(Icons.menu_book_outlined),
    selectedIcon: Icon(Icons.menu_book_rounded),
    label: 'Enrollments',
  ),
  NavigationDestination(
    icon: Icon(Icons.badge_outlined),
    selectedIcon: Icon(Icons.badge_rounded),
    label: 'Student ID',
  ),
];

const _railDestinations = <NavigationRailDestination>[
  NavigationRailDestination(
    icon: Icon(Icons.home_outlined),
    selectedIcon: Icon(Icons.home_rounded),
    label: Text('Home'),
  ),
  NavigationRailDestination(
    icon: Icon(Icons.fact_check_outlined),
    selectedIcon: Icon(Icons.fact_check_rounded),
    label: Text('Attendance'),
  ),
  NavigationRailDestination(
    icon: Icon(Icons.menu_book_outlined),
    selectedIcon: Icon(Icons.menu_book_rounded),
    label: Text('Enrollments'),
  ),
  NavigationRailDestination(
    icon: Icon(Icons.badge_outlined),
    selectedIcon: Icon(Icons.badge_rounded),
    label: Text('Student ID'),
  ),
];
