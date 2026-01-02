

import 'package:intl/intl.dart';

class TimestampHelper {
  // Format: 2025-01-02T15:30:00Z (ISO 8601)
  static String toIso8601(DateTime dateTime) {
    return dateTime.toUtc().toIso8601String();
  }

  // Parse ISO 8601 string to DateTime
  static DateTime fromIso8601(String dateTimeString) {
    return DateTime.parse(dateTimeString).toLocal();
  }

  // Get current timestamp in ISO 8601
  static String now() {
    return toIso8601(DateTime.now());
  }

  // Format untuk display: "02 Jan 2025, 15:30"
  static String formatDisplay(String? iso8601String) {
    if (iso8601String == null || iso8601String.isEmpty) {
      return '-';
    }
    
    try {
      final dateTime = fromIso8601(iso8601String);
      return DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(dateTime);
    } catch (e) {
      return '-';
    }
  }

  // Format hanya tanggal: "02 Jan 2025"
  static String formatDate(String? iso8601String) {
    if (iso8601String == null || iso8601String.isEmpty) {
      return '-';
    }
    
    try {
      final dateTime = fromIso8601(iso8601String);
      return DateFormat('dd MMM yyyy', 'id_ID').format(dateTime);
    } catch (e) {
      return '-';
    }
  }

  // Format hanya waktu: "15:30"
  static String formatTime(String? iso8601String) {
    if (iso8601String == null || iso8601String.isEmpty) {
      return '-';
    }
    
    try {
      final dateTime = fromIso8601(iso8601String);
      return DateFormat('HH:mm').format(dateTime);
    } catch (e) {
      return '-';
    }
  }

  // Calculate duration between two timestamps
  static Duration calculateDuration(String startTime, String endTime) {
    final start = fromIso8601(startTime);
    final end = fromIso8601(endTime);
    return end.difference(start);
  }

  // Format duration: "2 jam 30 menit"
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    
    if (hours > 0 && minutes > 0) {
      return '$hours jam $minutes menit';
    } else if (hours > 0) {
      return '$hours jam';
    } else if (minutes > 0) {
      return '$minutes menit';
    } else {
      return '${duration.inSeconds} detik';
    }
  }

  // Get relative time: "2 jam yang lalu"
  static String getRelativeTime(String iso8601String) {
    try {
      final dateTime = fromIso8601(iso8601String);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 0) {
        return '${difference.inDays} hari yang lalu';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} jam yang lalu';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} menit yang lalu';
      } else {
        return 'Baru saja';
      }
    } catch (e) {
      return '-';
    }
  }

  // Check if timestamp is today
  static bool isToday(String iso8601String) {
    try {
      final dateTime = fromIso8601(iso8601String);
      final now = DateTime.now();
      return dateTime.year == now.year &&
          dateTime.month == now.month &&
          dateTime.day == now.day;
    } catch (e) {
      return false;
    }
  }
}