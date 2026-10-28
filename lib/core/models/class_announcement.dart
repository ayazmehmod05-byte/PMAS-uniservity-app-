/// Fictional class announcement for the student demo.
class ClassAnnouncement {
  const ClassAnnouncement({
    required this.id,
    required this.title,
    required this.message,
    required this.category,
    required this.author,
    required this.timeAgo,
    this.isPinned = false,
    this.isRead = false,
  });

  final String id;
  final String title;
  final String message;
  final String category; // 'Class Notice', 'Academic', 'CR Notice', 'Reminder'
  final String author;
  final String timeAgo;
  final bool isPinned;
  final bool isRead;

  ClassAnnouncement copyWith({bool? isRead}) {
    return ClassAnnouncement(
      id: id,
      title: title,
      message: message,
      category: category,
      author: author,
      timeAgo: timeAgo,
      isPinned: isPinned,
      isRead: isRead ?? this.isRead,
    );
  }
}
