import 'package:equatable/equatable.dart';

class DateRange extends Equatable {
  final DateTime start;
  final DateTime end;

  const DateRange({
    required this.start,
    required this.end,
  });

  /// Create a date range for the last N days from today
  factory DateRange.lastDays(int days) {
    final end = DateTime.now();
    final start = end.subtract(Duration(days: days));
    return DateRange(start: start, end: end);
  }

  /// Create a date range for the current week (Monday to Sunday)
  factory DateRange.currentWeek() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final sunday = monday.add(const Duration(days: 6));
    return DateRange(
      start: DateTime(monday.year, monday.month, monday.day),
      end: DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59),
    );
  }

  /// Create a date range for the current month
  factory DateRange.currentMonth() {
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month, 1);
    final lastDay = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    return DateRange(start: firstDay, end: lastDay);
  }

  /// Create a date range for a specific week starting from a date
  factory DateRange.weekFrom(DateTime date) {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
    return DateRange(start: start, end: end);
  }

  /// Get the number of days in this range
  int get days => end.difference(start).inDays + 1;

  /// Check if a date is within this range
  bool contains(DateTime date) {
    return date.isAfter(start.subtract(const Duration(seconds: 1))) &&
        date.isBefore(end.add(const Duration(seconds: 1)));
  }

  @override
  List<Object?> get props => [start, end];

  @override
  String toString() => 'DateRange(${start.toIso8601String()} - ${end.toIso8601String()})';
}
