import 'package:flutter/material.dart';
import '../../app/app_colors.dart';
import '../../app/app_design_tokens.dart';
import '../../core/models/class_schedule_item.dart';

class ClassScheduleCard extends StatelessWidget {
  const ClassScheduleCard({
    required this.scheduleItems,
    this.onViewFullTimetable,
    super.key,
  });

  final List<ClassScheduleItem> scheduleItems;
  final VoidCallback? onViewFullTimetable;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
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
                    Icons.event_note_rounded,
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
                        "Today's Lectures",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryText,
                            ),
                      ),
                      const Text(
                        'BS Software Engineering • Section A',
                        style: TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onViewFullTimetable != null)
                  TextButton(
                    onPressed: onViewFullTimetable,
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    ),
                    child: const Text(
                      'Routine',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 12),
            if (scheduleItems.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text(
                    'No lectures scheduled for today.',
                    style: TextStyle(color: AppColors.secondaryText, fontSize: 13),
                  ),
                ),
              )
            else
              for (var i = 0; i < scheduleItems.length; i++) ...[
                _ScheduleItemRow(item: scheduleItems[i]),
                if (i != scheduleItems.length - 1)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(height: 1, indent: 24),
                  ),
              ],
          ],
        ),
      ),
    );
  }
}

class _ScheduleItemRow extends StatelessWidget {
  const _ScheduleItemRow({required this.item});

  final ClassScheduleItem item;

  @override
  Widget build(BuildContext context) {
    final statusColor = item.isCompleted
        ? AppColors.secondaryText
        : item.isCurrent
            ? AppColors.primaryGreen
            : AppColors.primaryText;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status indicator dot / icon
        Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: item.isCurrent
                  ? AppColors.primaryGreen
                  : item.isCompleted
                      ? AppColors.border
                      : AppColors.paleGreen,
              border: Border.all(
                color: item.isCurrent
                    ? AppColors.forestGreenDark
                    : item.isCompleted
                        ? AppColors.secondaryText
                        : AppColors.primaryGreen,
                width: 2,
              ),
            ),
            child: item.isCompleted
                ? const Icon(Icons.check, size: 8, color: AppColors.secondaryText)
                : null,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.subjectName,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: statusColor,
                        decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
                  if (item.isCurrent)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.paleGreen,
                        borderRadius: AppRadius.roundedXs,
                      ),
                      child: const Text(
                        'NOW',
                        style: TextStyle(
                          color: AppColors.forestGreenDark,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 3),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  _Badge(
                    icon: Icons.access_time_rounded,
                    label: item.timeSlot,
                  ),
                  _Badge(
                    icon: Icons.meeting_room_outlined,
                    label: item.room,
                  ),
                  _Badge(
                    icon: Icons.person_outline_rounded,
                    label: item.instructor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: AppColors.secondaryText),
        const SizedBox(width: 3),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.secondaryText,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
