/// Navigation index constants for the main [IndexedStack] shell.
///
/// The values must stay in sync with the destination lists in [AppShell]
/// (_barDestinations and _railDestinations in app.dart).
abstract final class AppRoutes {
  /// Home dashboard — index 0.
  static const int home = 0;

  /// Attendance screen — index 1.
  static const int attendance = 1;

  /// Enrollments screen — index 2.
  static const int enrollments = 2;

  /// Profile screen — index 3.
  static const int profile = 3;
}
