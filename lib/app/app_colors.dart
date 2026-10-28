import 'package:flutter/material.dart';

/// Centralized institutional color palette for PMAS-AAUR Student App.
/// Retains official university green identity, pale-green card surfaces,
/// and high-contrast accessible text.
abstract final class AppColors {
  // --- Core University Brand Colors ---
  static const primaryGreen = Color(0xFF358C42);
  static const forestGreenDark = Color(0xFF1E5E2A);
  static const paleGreen = Color(0xFFDEECE0);
  static const activeGreen = Color(0xFFA7D1AD);
  static const emeraldLight = Color(0xFFEBF5EE);

  // --- Surfaces and Neutrals ---
  static const background = Color(0xFFF5F7F5);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceSubtle = Color(0xFFF8FAF8);
  static const sidebarGrey = Color(0xFFE5E7EB);
  static const tableHeaderGrey = Color(0xFFD4D4D4);
  static const border = Color(0xFFD9DED9);
  static const cardBorder = Color(0xFFE2E7E2);
  static const divider = Color(0xFFE5EAE5);
  static const white = Color(0xFFFFFFFF);

  // --- Typography ---
  static const primaryText = Color(0xFF253329);
  static const secondaryText = Color(0xFF68746B);
  static const tertiaryText = Color(0xFF8F9C92);

  // --- Status & Feedback Tones ---
  static const warning = Color(0xFF9A6700);
  static const warningSurface = Color(0xFFFFF4D6);

  static const success = Color(0xFF2E7D32);
  static const successSurface = Color(0xFFE8F5E9);

  static const caution = Color(0xFFD97706);
  static const cautionSurface = Color(0xFFFEF3C7);

  static const danger = Color(0xFFC62828);
  static const dangerSurface = Color(0xFFFEE2E2);

  static const info = Color(0xFF1D4ED8);
  static const infoSurface = Color(0xFFEFF6FF);
}
