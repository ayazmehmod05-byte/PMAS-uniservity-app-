import 'package:flutter/material.dart';
import '../../app/app_colors.dart';
import '../../app/app_design_tokens.dart';

class UniversityHeader extends StatelessWidget {
  const UniversityHeader({
    required this.onNotificationsPressed,
    this.unreadNotificationsCount = 2,
    super.key,
  });

  final VoidCallback onNotificationsPressed;
  final int unreadNotificationsCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 360;

          return Row(
            children: [
              Semantics(
                image: true,
                label: 'PMAS Arid Agriculture University Rawalpindi',
                child: Image.asset(
                  'assets/images/pmas_aaur_wordmark.png',
                  width: isNarrow ? 150 : 185,
                  height: 38,
                  fit: BoxFit.contain,
                  excludeFromSemantics: true,
                ),
              ),
              const Spacer(),
              if (!isNarrow) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.paleGreen,
                    borderRadius: AppRadius.roundedPill,
                    border: Border.all(color: AppColors.activeGreen.withValues(alpha: 0.6)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.school, size: 12, color: AppColors.forestGreenDark),
                      SizedBox(width: 4),
                      Text(
                        'BSSE-3A',
                        style: TextStyle(
                          color: AppColors.forestGreenDark,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
              ],
              IconButton(
                onPressed: onNotificationsPressed,
                tooltip: 'Class notices & announcements',
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.surfaceSubtle,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: AppColors.cardBorder),
                  ),
                ),
                icon: Badge(
                  isLabelVisible: unreadNotificationsCount > 0,
                  label: Text('$unreadNotificationsCount'),
                  backgroundColor: AppColors.primaryGreen,
                  textColor: AppColors.white,
                  child: const Icon(
                    Icons.notifications_none_rounded,
                    color: AppColors.primaryText,
                    size: 20,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
