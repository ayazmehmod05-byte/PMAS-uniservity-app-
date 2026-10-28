import 'package:flutter/material.dart';

import '../core/data/mock_data.dart';
import '../features/attendance/attendance_screen.dart';
import '../features/enrollments/enrollments_screen.dart';
import '../features/home/home_screen.dart';
import '../features/notifications/notifications_screen.dart';
import '../features/profile/profile_screen.dart';
import '../shared/widgets/university_header.dart';
import 'app_colors.dart';
import 'app_theme.dart';

class StudentPortalApp extends StatelessWidget {
  const StudentPortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PMAS-AAUR Student App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(),
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  void _selectDestination(int index) {
    setState(() => _selectedIndex = index);
  }

  void _showAcademicRecord() {
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
                'Academic record',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              const Text(
                'This sample project currently shows a summary only. '
                'No official academic record is connected.',
              ),
              const SizedBox(height: 20),
              Text('${mockCourses.length} sample courses'),
              const SizedBox(height: 6),
              Text('${totalCreditHours(mockCourses)} total credit hours'),
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
                        Icons.school_outlined,
                        color: AppColors.primaryGreen,
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

const _barDestinations = <NavigationDestination>[
  NavigationDestination(
    icon: Icon(Icons.home_outlined),
    selectedIcon: Icon(Icons.home),
    label: 'Home',
  ),
  NavigationDestination(
    icon: Icon(Icons.fact_check_outlined),
    selectedIcon: Icon(Icons.fact_check),
    label: 'Attendance',
  ),
  NavigationDestination(
    icon: Icon(Icons.menu_book_outlined),
    selectedIcon: Icon(Icons.menu_book),
    label: 'Enrollments',
  ),
  NavigationDestination(
    icon: Icon(Icons.person_outline),
    selectedIcon: Icon(Icons.person),
    label: 'Profile',
  ),
];

const _railDestinations = <NavigationRailDestination>[
  NavigationRailDestination(
    icon: Icon(Icons.home_outlined),
    selectedIcon: Icon(Icons.home),
    label: Text('Home'),
  ),
  NavigationRailDestination(
    icon: Icon(Icons.fact_check_outlined),
    selectedIcon: Icon(Icons.fact_check),
    label: Text('Attendance'),
  ),
  NavigationRailDestination(
    icon: Icon(Icons.menu_book_outlined),
    selectedIcon: Icon(Icons.menu_book),
    label: Text('Enrollments'),
  ),
  NavigationRailDestination(
    icon: Icon(Icons.person_outline),
    selectedIcon: Icon(Icons.person),
    label: Text('Profile'),
  ),
];
