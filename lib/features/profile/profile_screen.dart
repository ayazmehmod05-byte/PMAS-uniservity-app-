import 'package:flutter/material.dart';

import '../../app/app_colors.dart';
import '../../shared/widgets/section_header.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      children: [
        const SectionHeader(
          title: 'My profile',
          subtitle: 'Fictional, non-sensitive demo information.',
        ),
        const SizedBox(height: 20),
        const _IdentityCard(),
        const SizedBox(height: 24),
        const _ProfileGroup(
          title: 'Academic information',
          icon: Icons.school_outlined,
          fields: [
            _ProfileField(label: 'Programme', value: 'BS Software Engineering'),
            _ProfileField(
              label: 'Department',
              value: 'University Institute of Information Technology',
            ),
            _ProfileField(label: 'Semester', value: 'Semester 3'),
            _ProfileField(
              label: 'Registration ID',
              value: 'DEMO-SE-2026-001',
              isDemo: true,
            ),
          ],
        ),
        const SizedBox(height: 16),
        const _ProfileGroup(
          title: 'Personal information',
          icon: Icons.person_outline,
          fields: [
            _ProfileField(
              label: 'Email',
              value: 'sample.student@example.edu',
              isDemo: true,
            ),
            _ProfileField(label: 'City', value: 'Rawalpindi', isDemo: true),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: const Text(
            'Profile editing is intentionally unavailable in this offline prototype. No changes are sent to a university server.',
          ),
        ),
      ],
    );
  }
}

class _IdentityCard extends StatelessWidget {
  const _IdentityCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 32,
              backgroundColor: AppColors.paleGreen,
              foregroundColor: AppColors.primaryGreen,
              child: Text(
                'SS',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sample Student',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'BS Software Engineering  •  Semester 3',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 10),
                  const _DemoStatus(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DemoStatus extends StatelessWidget {
  const _DemoStatus();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.paleGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'Sample project profile',
        style: TextStyle(
          color: AppColors.primaryText,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ProfileGroup extends StatelessWidget {
  const _ProfileGroup({
    required this.title,
    required this.icon,
    required this.fields,
  });

  final String title;
  final IconData icon;
  final List<_ProfileField> fields;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primaryGreen),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(height: 1),
            for (var index = 0; index < fields.length; index++) ...[
              const SizedBox(height: 14),
              fields[index],
              if (index != fields.length - 1) ...[
                const SizedBox(height: 14),
                const Divider(height: 1),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({
    required this.label,
    required this.value,
    this.isDemo = false,
  });

  final String label;
  final String value;
  final bool isDemo;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.secondaryText),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 3,
          child: Wrap(
            spacing: 8,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
              if (isDemo)
                const Text(
                  '(demo)',
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
