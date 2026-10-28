import 'package:flutter/material.dart';

import '../../app/app_colors.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo notifications'),
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          _NotificationNotice(),
          SizedBox(height: 16),
          _NotificationTile(
            icon: Icons.fact_check_outlined,
            title: 'Attendance overview ready',
            message: 'Review the locally calculated sample attendance figures.',
          ),
          SizedBox(height: 12),
          _NotificationTile(
            icon: Icons.menu_book_outlined,
            title: 'Enrollment list updated',
            message:
                'Course records are fictional data bundled with the prototype.',
          ),
        ],
      ),
    );
  }
}

class _NotificationNotice extends StatelessWidget {
  const _NotificationNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.paleGreen,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.activeGreen),
      ),
      child: const Text(
        'These are mock notifications for the offline sample project. They are not official university communications.',
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
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
                        ?.copyWith(fontWeight: FontWeight.w800),
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
