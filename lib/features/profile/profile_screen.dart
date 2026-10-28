import 'package:flutter/material.dart';

import '../../app/app_colors.dart';
import '../../app/app_design_tokens.dart';
import '../../core/data/mock_data.dart';
import '../../shared/widgets/section_header.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showInfoModal(BuildContext context, String title, String content) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryText,
                    ),
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 14),
              Text(
                content,
                style: const TextStyle(fontSize: 13, height: 1.5, color: AppColors.primaryText),
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
                  'PMAS-AAUR Student Portal Demo • Informational reference only.',
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
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        const SectionHeader(
          title: 'Student Identity',
          subtitle: 'Academic credentials & class profile.',
          badgeText: 'Stage 1 Class',
        ),
        const SizedBox(height: 14),

        // Digital University Student Card
        const _DigitalStudentIdCard(),
        const SizedBox(height: 20),

        // Academic Details Group
        const _ProfileGroup(
          title: 'Academic Details',
          icon: Icons.school_rounded,
          fields: [
            _ProfileField(label: 'Degree Programme', value: MockStudentProfile.degree),
            _ProfileField(label: 'Department', value: MockStudentProfile.department),
            _ProfileField(label: 'Faculty', value: MockStudentProfile.faculty),
            _ProfileField(label: 'Class & Shift', value: '${MockStudentProfile.section} (${MockStudentProfile.shift})'),
            _ProfileField(label: 'Current Semester', value: MockStudentProfile.semester),
            _ProfileField(label: 'Academic Session', value: MockStudentProfile.session),
            _ProfileField(
              label: 'Registration ID',
              value: MockStudentProfile.registrationId,
              isDemo: true,
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Personal Information Group (Non-sensitive demo)
        const _ProfileGroup(
          title: 'Student Information',
          icon: Icons.badge_outlined,
          fields: [
            _ProfileField(
              label: 'Student Email',
              value: MockStudentProfile.email,
              isDemo: true,
            ),
            _ProfileField(label: 'Campus', value: MockStudentProfile.campus),
            _ProfileField(label: 'Batch Tenure', value: MockStudentProfile.batch),
            _ProfileField(label: 'Blood Group', value: MockStudentProfile.bloodGroup, isDemo: true),
          ],
        ),
        const SizedBox(height: 16),

        // Student Services / Class Shortcuts
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.hub_outlined, color: AppColors.primaryGreen, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Student Quick Links',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryText,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                _LinkTile(
                  icon: Icons.calendar_month_outlined,
                  title: 'Academic Calendar 2026',
                  subtitle: 'Term dates, midterm & final schedules',
                  onTap: () => _showInfoModal(
                    context,
                    'Academic Calendar 2026',
                    'Fall 2026 Semester Schedule:\n'
                    '• Classes Commence: First week of September\n'
                    '• Midterm Examinations: 9th week of semester\n'
                    '• Final Examinations: 18th week of semester\n\n'
                    'Note: Dates are based on standard PMAS-AAUR semester regulations.',
                  ),
                ),
                const Divider(height: 1, indent: 40),
                _LinkTile(
                  icon: Icons.gavel_outlined,
                  title: 'Examination Regulations',
                  subtitle: '75% attendance rule & grading criteria',
                  onTap: () => _showInfoModal(
                    context,
                    'Examination Regulations',
                    'Key PMAS-AAUR Examination Policy Guidelines:\n'
                    '1. Minimum 75% attendance is required in each theory and lab course to be eligible for terminal examinations.\n'
                    '2. Relative/Absolute grading policy as notified by the Controller of Examinations.\n'
                    '3. Minimum CGPA of 2.00 is required for graduation in undergraduate degree programmes.',
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // App & Prototype Info Banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceSubtle,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.verified_outlined, size: 16, color: AppColors.primaryGreen),
                  SizedBox(width: 6),
                  Text(
                    'PMAS Class App • Stage 1 Release',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                      color: AppColors.primaryText,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                'This mobile frontend is an offline prototype for BS Software Engineering (Semester 3). All records are local demo figures. No changes are sent to live university databases.',
                style: TextStyle(color: AppColors.secondaryText, fontSize: 11, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DigitalStudentIdCard extends StatelessWidget {
  const _DigitalStudentIdCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.paleGreen,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.activeGreen, width: 1.2),
        boxShadow: AppShadows.card,
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.school_rounded,
                  color: AppColors.primaryGreen,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PMAS-AAUR STUDENT ID',
                      style: TextStyle(
                        color: AppColors.forestGreenDark,
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      'Arid Agriculture University Rawalpindi',
                      style: TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.activeGreen),
                ),
                child: const Text(
                  'VALID 2023-27',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: AppColors.forestGreenDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.activeGreen),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 32,
                backgroundColor: AppColors.white,
                child: Text(
                  MockStudentProfile.initials,
                  style: TextStyle(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      MockStudentProfile.degree,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.forestGreenDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Reg: ${MockStudentProfile.registrationId} • ${MockStudentProfile.rollNumber}',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.secondaryText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Section: A (Morning)',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primaryText),
                ),
                Text(
                  'Status: Regular Enrolled',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primaryGreen),
                ),
              ],
            ),
          ),
        ],
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primaryGreen, size: 20),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryText,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            for (var i = 0; i < fields.length; i++) ...[
              const SizedBox(height: 10),
              fields[i],
              if (i != fields.length - 1) ...[
                const SizedBox(height: 10),
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
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.secondaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 3,
          child: Wrap(
            spacing: 6,
            runSpacing: 2,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryText,
                ),
              ),
              if (isDemo)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSubtle,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: const Text(
                    'demo',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LinkTile extends StatelessWidget {
  const _LinkTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.paleGreen,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primaryGreen, size: 18),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.secondaryText),
      onTap: onTap,
    );
  }
}
