import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Centralized design tokens for PMAS-AAUR Student Class App.
/// Provides consistent spacing, corner radii, elevation shadows, and animation durations.
abstract final class AppSpacing {
  static const double xxs = 4.0;
  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 20.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double xxxl = 40.0;
}

abstract final class AppRadius {
  static const double xs = 6.0;
  static const double sm = 10.0;
  static const double md = 14.0;
  static const double lg = 18.0;
  static const double xl = 24.0;
  static const double pill = 999.0;

  static BorderRadius get roundedXs => BorderRadius.circular(xs);
  static BorderRadius get roundedSm => BorderRadius.circular(sm);
  static BorderRadius get roundedMd => BorderRadius.circular(md);
  static BorderRadius get roundedLg => BorderRadius.circular(lg);
  static BorderRadius get roundedXl => BorderRadius.circular(xl);
  static BorderRadius get roundedPill => BorderRadius.circular(pill);
}

abstract final class AppShadows {
  /// Subtle institutional shadow for mobile cards
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x0A102A16),
      blurRadius: 10,
      offset: Offset(0, 2),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x06102A16),
      blurRadius: 4,
      offset: Offset(0, 1),
      spreadRadius: 0,
    ),
  ];

  /// Floating card / modal shadow
  static const List<BoxShadow> floating = [
    BoxShadow(
      color: Color(0x14102A16),
      blurRadius: 16,
      offset: Offset(0, 4),
      spreadRadius: -2,
    ),
  ];

  /// Subtle top header border shadow
  static const List<BoxShadow> header = [
    BoxShadow(
      color: Color(0x08102A16),
      blurRadius: 6,
      offset: Offset(0, 2),
    ),
  ];
}

abstract final class AppDurations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration standard = Duration(milliseconds: 250);
  static const Duration smooth = Duration(milliseconds: 350);
}

/// Text style helper to ensure unified typography and letter spacing across the app
abstract final class AppTypography {
  static const TextStyle displayTitle = TextStyle(
    color: AppColors.primaryText,
    fontSize: 22,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.4,
    height: 1.25,
  );

  static const TextStyle sectionTitle = TextStyle(
    color: AppColors.primaryText,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    height: 1.3,
  );

  static const TextStyle cardTitle = TextStyle(
    color: AppColors.primaryText,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
    height: 1.3,
  );

  static const TextStyle bodyRegular = TextStyle(
    color: AppColors.primaryText,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.1,
    height: 1.45,
  );

  static const TextStyle bodyMuted = TextStyle(
    color: AppColors.secondaryText,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.1,
    height: 1.45,
  );

  static const TextStyle caption = TextStyle(
    color: AppColors.secondaryText,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.3,
  );

  static const TextStyle chipLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  static const TextStyle metricValue = TextStyle(
    color: AppColors.primaryText,
    fontSize: 20,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.3,
  );
}
