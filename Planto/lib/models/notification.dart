class Notification {
  final String id;
  final String userId;
  final String title;
  final String message;
  final String time;
  final bool isRead;
  final NotificationType type;
  final DateTime createdAt;

  Notification({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.time,
    this.isRead = false,
    required this.type,
    required this.createdAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      userId: json['user']?['_id']?.toString() ?? json['userId']?.toString() ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      time: json['time'] ?? _formatTime(json['createdAt']),
      isRead: json['isRead'] ?? false,
      type: _parseNotificationType(json['type']),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'message': message,
      'time': time,
      'isRead': isRead,
      'type': type.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static String _formatTime(dynamic dateTime) {
    if (dateTime == null) return 'Just now';
    final date = DateTime.parse(dateTime.toString());
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return '${date.day}/${date.month}/${date.year}';
  }

  static NotificationType _parseNotificationType(String? type) {
    switch (type?.toLowerCase()) {
      case 'order':
        return NotificationType.order;
      case 'watering':
        return NotificationType.watering;
      case 'promotion':
        return NotificationType.promotion;
      default:
        return NotificationType.general;
    }
  }
}

enum NotificationType {
  order,
  watering,
  promotion,
  general,
}
