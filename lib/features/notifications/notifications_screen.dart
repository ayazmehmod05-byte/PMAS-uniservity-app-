import 'package:flutter/material.dart';

import '../../app/app_colors.dart';
import '../../shared/widgets/empty_state.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _selectedFilterIndex = 0;
  final Set<String> _readIds = {'notif-1'};

  final List<Map<String, dynamic>> _allNotifications = [
    {
      'id': 'notif-1',
      'title': 'Computer Networks Lab 3 Report Due',
      'message':
          'Please ensure packet tracer simulation topology is submitted on Google Classroom before Friday 11:59 PM. Lab manual section 4.2.',
      'category': 'Class CR Notice',
      'time': '2 hours ago',
      'icon': Icons.assignment_outlined,
      'isAcademic': false,
    },
    {
      'id': 'notif-2',
      'title': 'Tentative Midterm Examination Schedule',
      'message':
          'Midterm examination dates for Fall 2026 have been posted on the department board. Ensure at least 75% attendance for admit slips.',
      'category': 'Academic Notice',
      'time': 'Yesterday',
      'icon': Icons.calendar_month_outlined,
      'isAcademic': true,
    },
    {
      'id': 'notif-3',
      'title': 'Software Engineering Guest Lecture',
      'message':
          'Industry expert seminar on Agile Scrum methodologies scheduled for Thursday at UIIT Seminar Hall. Attendance will be marked.',
      'category': 'Class Event',
      'time': '3 days ago',
      'icon': Icons.campaign_outlined,
      'isAcademic': false,
    },
    {
      'id': 'notif-4',
      'title': 'Attendance Overview Ready for Review',
      'message':
          'Review your locally calculated sample attendance records before class review. Check records that fall below 50%.',
      'category': 'Portal Notice',
      'time': '4 days ago',
      'icon': Icons.fact_check_outlined,
      'isAcademic': true,
    },
  ];

  List<Map<String, dynamic>> get _filteredNotifications {
    if (_selectedFilterIndex == 1) {
      return _allNotifications.where((n) => n['isAcademic'] == false).toList();
    } else if (_selectedFilterIndex == 2) {
      return _allNotifications.where((n) => n['isAcademic'] == true).toList();
    }
    return _allNotifications;
  }

  void _markAllAsRead() {
    setState(() {
      for (final n in _allNotifications) {
        _readIds.add(n['id'] as String);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _openNotificationDetail(Map<String, dynamic> notif) {
    setState(() {
      _readIds.add(notif['id'] as String);
    });

    showModalBottomSheet<void>(
      context: context,
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
                      notif['category'] as String,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.forestGreenDark,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    notif['time'] as String,
                    style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                notif['title'] as String,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryText,
                    ),
              ),
              const SizedBox(height: 14),
              const Divider(height: 1),
              const SizedBox(height: 14),
              Text(
                notif['message'] as String,
                style: const TextStyle(fontSize: 14, height: 1.5, color: AppColors.primaryText),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSubtle,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'BS Software Engineering (Semester 3, Section A) • Sample Class Notice',
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
    final list = _filteredNotifications;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Notices & Alerts'),
        actions: [
          TextButton.icon(
            onPressed: _markAllAsRead,
            icon: const Icon(Icons.done_all, size: 16),
            label: const Text('Read all'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primaryGreen,
              textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: AppColors.white,
              border: Border(bottom: BorderSide(color: AppColors.divider)),
            ),
            child: Row(
              children: [
                _buildFilterChip(0, 'All (${_allNotifications.length})'),
                const SizedBox(width: 8),
                _buildFilterChip(1, 'Class Notices'),
                const SizedBox(width: 8),
                _buildFilterChip(2, 'Academic'),
              ],
            ),
          ),

          // Offline Disclaimer
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.paleGreen,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.activeGreen),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, size: 14, color: AppColors.forestGreenDark),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Sample class updates for BSSE-3A. Not official university alerts.',
                    style: TextStyle(fontSize: 11, color: AppColors.forestGreenDark, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),

          // Notification List
          Expanded(
            child: list.isEmpty
                ? const EmptyState(
                    icon: Icons.notifications_off_outlined,
                    title: 'No notifications in this tab',
                    message: 'Select another filter category to review updates.',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    itemCount: list.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = list[index];
                      final isRead = _readIds.contains(item['id']);

                      return Card(
                        clipBehavior: Clip.antiAlias,
                        color: isRead ? AppColors.white : const Color(0xFFFCFEFC),
                        child: InkWell(
                          onTap: () => _openNotificationDetail(item),
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: isRead ? AppColors.surfaceSubtle : AppColors.paleGreen,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: isRead ? AppColors.cardBorder : AppColors.activeGreen,
                                    ),
                                  ),
                                  child: Icon(
                                    item['icon'] as IconData,
                                    color: isRead ? AppColors.secondaryText : AppColors.primaryGreen,
                                    size: 20,
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
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              item['category'] as String,
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                                color: isRead ? AppColors.secondaryText : AppColors.primaryGreen,
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            item['time'] as String,
                                            style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
                                          ),
                                          if (!isRead) ...[
                                            const SizedBox(width: 6),
                                            Container(
                                              width: 7,
                                              height: 7,
                                              decoration: const BoxDecoration(
                                                color: AppColors.primaryGreen,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        item['title'] as String,
                                        style: TextStyle(
                                          fontWeight: isRead ? FontWeight.w700 : FontWeight.w800,
                                          fontSize: 13,
                                          color: AppColors.primaryText,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        item['message'] as String,
                                        style: const TextStyle(fontSize: 12, color: AppColors.secondaryText),
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
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(int index, String label) {
    final isSelected = _selectedFilterIndex == index;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => setState(() => _selectedFilterIndex = index),
      selectedColor: AppColors.paleGreen,
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        color: isSelected ? AppColors.forestGreenDark : AppColors.primaryText,
      ),
    );
  }
}
