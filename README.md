# PMAS-AAUR Student App

A polished, offline Flutter frontend prototype inspired by the Pir Mehr Ali Shah Arid Agriculture University Rawalpindi (PMAS-AAUR) student portal.

> **All content is fictional demo data.** This prototype is not connected to any university system, does not use real student credentials, and contains no genuine student records.

---

## Features

| Screen | What it shows |
|---|---|
| **Home** | Welcome card, academic summary (courses, credit hours, overall attendance), quick-action grid, attendance overview, mock announcements |
| **Attendance** | Live-filtered subject list with per-subject progress bars, overall attendance summary card, semester filter, bottom-sheet detail view |
| **Enrollments** | Searchable course cards (phone) / data table (wide screen), semester filter, credit-hour total |
| **Profile** | Student identity card, grouped academic & personal fields, demo notices |
| **Notifications** | Mock notification list pushed as a separate route |

- **Responsive layout** — bottom `NavigationBar` on phones; `NavigationRail` on screens ≥ 760 px wide.
- **University branding** — PMAS-AAUR logo/wordmark asset, provisional green colour tokens in a single theme file.
- **All calculations are safe** — division-by-zero guard in `attendancePercentage`; overall attendance uses combined totals, not a simple average of percentages.

---

## Getting started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) — verified against **≥ 3.33** (SDK constraint `>=3.11.0 <4.0.0`)
- An Android emulator, iOS simulator, or physical device (or `flutter run -d chrome` for a quick web preview)

### Steps

```bash
# 1 — fetch dependencies (no external packages; only Flutter SDK packages)
flutter pub get

# 2 — run on the default connected device
flutter run

# Run on a specific device (list available first)
flutter devices
flutter run -d <device-id>
```

### Static analysis

```bash
flutter analyze
# Expected: No issues found.
```

### Tests

```bash
flutter test
# Runs all unit tests in test/academic_calculations_test.dart
# Covers attendancePercentage, progressValue, percentageLabel,
# overallAttendancePercentage, totalCreditHours, and mock data integrity.
```

---

## Project structure

```
lib/
  main.dart                      — entry point
  app/
    app.dart                     — MaterialApp + AppShell (navigation shell)
    app_colors.dart              — centralized colour tokens (provisional)
    app_theme.dart               — ThemeData, ColorScheme, widget themes
  core/
    data/
      mock_data.dart             — local fictional records + totalCreditHours helper
    models/
      attendance_record.dart     — AttendanceRecord data class
      course.dart                — Course data class
    utils/
      academic_calculations.dart — attendancePercentage, overallAttendancePercentage,
                                   percentageLabel, progressValue
  features/
    home/
      home_screen.dart           — dashboard (welcome card, summary, quick actions,
                                   attendance preview, announcements)
    attendance/
      attendance_screen.dart     — filterable attendance list + detail bottom sheet
    enrollments/
      enrollments_screen.dart    — filterable course list (cards + table)
    profile/
      profile_screen.dart        — grouped student profile fields
    notifications/
      notifications_screen.dart  — mock notification list
  shared/
    widgets/
      university_header.dart     — top app bar with logo + notifications icon
      section_header.dart        — reusable section title + optional action button
      summary_card.dart          — icon + value + label metric tile
      empty_state.dart           — icon + title + message centred empty state
      app_search_field.dart      — styled TextField with search icon
assets/
  images/
    pmas_aaur_wordmark.png       — university logo/wordmark (bundled asset)
test/
  academic_calculations_test.dart — unit tests for all calculation helpers
                                    and mock data integrity checks
```

---

## Colour tokens (provisional)

These values were derived from the supplied student portal screenshots and are stored exclusively in [`lib/app/app_colors.dart`](lib/app/app_colors.dart). Replace them there to update the whole app.

| Token | Hex | Usage |
|---|---|---|
| `primaryGreen` | `#358C42` | Primary actions, icons, active states |
| `paleGreen` | `#DEECE0` | Card backgrounds, filter chips |
| `activeGreen` | `#A7D1AD` | Navigation indicator, card borders |
| `sidebarGrey` | `#E5E7EB` | Rail backgrounds |
| `tableHeaderGrey` | `#D4D4D4` | Data table header rows |
| `background` | `#F5F7F5` | Scaffold background |
| `primaryText` | `#253329` | Body text, headings |
| `secondaryText` | `#68746B` | Labels, captions, hints |
| `border` | `#D9DED9` | Card and input borders |

---

## Typography

No university font files were available or bundled. The app uses the platform Material sans-serif typeface (Roboto on Android, SF Pro on iOS). If official font files are later licensed and supplied, add them under `assets/fonts/` and reference them in `pubspec.yaml` and `app_theme.dart`.

---

## Limitations and assumptions

- **Offline only** — no network calls, no backend, no authentication.
- **Demo data only** — all student names, registration IDs, and course records are fictional.
- **No state-management package** — `setState` is used; suitable for this small prototype.
- **No platform channels or plugins** — pure Flutter + Material SDK.
- Brand colours are screenshot-derived approximations, not verified official values.
