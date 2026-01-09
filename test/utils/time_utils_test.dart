import 'package:flutter_test/flutter_test.dart';
import 'package:task_flow/core/utils/time_utils.dart';

void main() {
  group('TimeUtils Tests', () {
    group('getTimeAgo', () {
      test('returns "Just now" for very recent time', () {
        final now = DateTime.now();
        final result = TimeUtils.getTimeAgo(now);
        expect(result, 'Just now');
      });

      test('returns minutes ago for recent time', () {
        final fiveMinutesAgo = DateTime.now().subtract(Duration(minutes: 5));
        final result = TimeUtils.getTimeAgo(fiveMinutesAgo);
        expect(result, '5m ago');
      });

      test('returns hours ago for time within a day', () {
        final threeHoursAgo = DateTime.now().subtract(Duration(hours: 3));
        final result = TimeUtils.getTimeAgo(threeHoursAgo);
        expect(result, '3h ago');
      });

      test('returns days ago for time within a week', () {
        final twoDaysAgo = DateTime.now().subtract(Duration(days: 2));
        final result = TimeUtils.getTimeAgo(twoDaysAgo);
        expect(result, '2d ago');
      });

      test('returns weeks ago for time over a week', () {
        final twoWeeksAgo = DateTime.now().subtract(Duration(days: 14));
        final result = TimeUtils.getTimeAgo(twoWeeksAgo);
        expect(result, '2w ago');
      });

      test('returns correct value for exactly 1 hour ago', () {
        final oneHourAgo = DateTime.now().subtract(Duration(hours: 1));
        final result = TimeUtils.getTimeAgo(oneHourAgo);
        expect(result, '1h ago');
      });

      test('returns correct value for exactly 1 day ago', () {
        final oneDayAgo = DateTime.now().subtract(Duration(days: 1));
        final result = TimeUtils.getTimeAgo(oneDayAgo);
        expect(result, '1d ago');
      });
    });

    group('formatDate', () {
      test('returns "Today" for current date', () {
        final today = DateTime.now();
        final result = TimeUtils.formatDate(today);
        expect(result, 'Today');
      });

      test('returns "Yesterday" for yesterday', () {
        final yesterday = DateTime.now().subtract(Duration(days: 1));
        final result = TimeUtils.formatDate(yesterday);
        expect(result, 'Yesterday');
      });

      test('returns formatted date for older dates', () {
        final date = DateTime(2023, 5, 15);
        final result = TimeUtils.formatDate(date);
        expect(result, '15/5/2023');
      });

      test('handles different times on same day as Today', () {
        final now = DateTime.now();
        final morningToday = DateTime(now.year, now.month, now.day, 6, 0);
        final result = TimeUtils.formatDate(morningToday);
        expect(result, 'Today');
      });

      test('handles different times on yesterday', () {
        final now = DateTime.now();
        final yesterdayDate = DateTime(now.year, now.month, now.day - 1, 23, 59);
        final result = TimeUtils.formatDate(yesterdayDate);
        expect(result, 'Yesterday');
      });
    });

    group('isOverdue', () {
      test('returns false when dueDate is null', () {
        final result = TimeUtils.isOverdue(null);
        expect(result, false);
      });

      test('returns false when task is completed', () {
        final pastDate = DateTime.now().subtract(Duration(days: 1));
        final result = TimeUtils.isOverdue(pastDate, isCompleted: true);
        expect(result, false);
      });

      test('returns true for past due date', () {
        final pastDate = DateTime.now().subtract(Duration(days: 1));
        final result = TimeUtils.isOverdue(pastDate, isCompleted: false);
        expect(result, true);
      });

      test('returns false for future due date', () {
        final futureDate = DateTime.now().add(Duration(days: 1));
        final result = TimeUtils.isOverdue(futureDate, isCompleted: false);
        expect(result, false);
      });

      test('returns false for current time', () {
        final now = DateTime.now();
        final result = TimeUtils.isOverdue(now, isCompleted: false);
        expect(result, false);
      });
    });
  });
}
