import 'package:flutter/material.dart';

import '../../app/app_colors.dart';

class UniversityHeader extends StatelessWidget {
  const UniversityHeader({required this.onNotificationsPressed, super.key});

  final VoidCallback onNotificationsPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Semantics(
            image: true,
            label: 'PMAS Arid Agriculture University Rawalpindi',
            child: Image.asset(
              'assets/images/pmas_aaur_wordmark.png',
              width: 208,
              fit: BoxFit.contain,
              excludeFromSemantics: true,
            ),
          ),
          const Spacer(),
          const _DemoPill(),
          const SizedBox(width: 6),
          IconButton(
            onPressed: onNotificationsPressed,
            tooltip: 'Open demo notifications',
            icon: const Badge(
              smallSize: 8,
              child: Icon(Icons.notifications_none_outlined),
            ),
          ),
        ],
      ),
    );
  }
}

class _DemoPill extends StatelessWidget {
  const _DemoPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.paleGreen,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Demo data',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.primaryText,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
