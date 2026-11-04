import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_flow/core/models/task_category.dart';

void main() {
  group('TaskCategory', () {
    test('should have all predefined categories', () {
      expect(TaskCategory.design.id, 'design');
      expect(TaskCategory.dev.id, 'dev');
      expect(TaskCategory.marketing.id, 'marketing');
      expect(TaskCategory.research.id, 'research');
      expect(TaskCategory.bug.id, 'bug');
      expect(TaskCategory.general.id, 'general');
      expect(TaskCategory.meeting.id, 'meeting');
    });

    test('should have correct names for predefined categories', () {
      expect(TaskCategory.design.name, 'Design');
      expect(TaskCategory.dev.name, 'Dev');
      expect(TaskCategory.marketing.name, 'Mktg');
      expect(TaskCategory.research.name, 'Rsrch');
      expect(TaskCategory.bug.name, 'Bug');
      expect(TaskCategory.general.name, 'General');
      expect(TaskCategory.meeting.name, 'Meeting');
    });

    test('should have correct icons for predefined categories', () {
      expect(TaskCategory.design.icon, Icons.edit);
      expect(TaskCategory.dev.icon, Icons.code);
      expect(TaskCategory.marketing.icon, Icons.campaign);
      expect(TaskCategory.research.icon, Icons.science);
      expect(TaskCategory.bug.icon, Icons.bug_report);
      expect(TaskCategory.general.icon, Icons.task_alt);
      expect(TaskCategory.meeting.icon, Icons.groups);
    });

    test('should have correct colors for predefined categories', () {
      expect(TaskCategory.design.color, const Color(0xFF8B5CF6)); // Purple
      expect(TaskCategory.dev.color, const Color(0xFF2E90FA)); // Blue
      expect(TaskCategory.marketing.color, const Color(0xFFF59E0B)); // Orange
      expect(TaskCategory.research.color, const Color(0xFF06B6D4)); // Cyan
      expect(TaskCategory.bug.color, const Color(0xFFEF4444)); // Red
      expect(TaskCategory.general.color, const Color(0xFF10B981)); // Green
      expect(TaskCategory.meeting.color, const Color(0xFF14B8A6)); // Teal
    });

    test('should return all categories in correct order', () {
      final all = TaskCategory.all;

      expect(all.length, 7);
      expect(all[0], TaskCategory.general);
      expect(all[1], TaskCategory.meeting);
      expect(all[2], TaskCategory.marketing);
      expect(all[3], TaskCategory.research);
      expect(all[4], TaskCategory.design);
      expect(all[5], TaskCategory.dev);
      expect(all[6], TaskCategory.bug);
    });

    test('should find category by id', () {
      expect(TaskCategory.fromId('design'), TaskCategory.design);
      expect(TaskCategory.fromId('dev'), TaskCategory.dev);
      expect(TaskCategory.fromId('bug'), TaskCategory.bug);
      expect(TaskCategory.fromId('general'), TaskCategory.general);
    });

    test('should return null for invalid id in fromId', () {
      expect(TaskCategory.fromId('invalid'), null);
      expect(TaskCategory.fromId(''), null);
    });

    test('should return null for null id in fromId', () {
      expect(TaskCategory.fromId(null), null);
    });

    test('should get category by id with fallback to general', () {
      expect(TaskCategory.getById('design'), TaskCategory.design);
      expect(TaskCategory.getById('dev'), TaskCategory.dev);
    });

    test('should return general for invalid id in getById', () {
      expect(TaskCategory.getById('invalid'), TaskCategory.general);
      expect(TaskCategory.getById(''), TaskCategory.general);
    });

    test('should return general for null id in getById', () {
      expect(TaskCategory.getById(null), TaskCategory.general);
    });

    test('categories should be const and comparable', () {
      final cat1 = TaskCategory.design;
      final cat2 = TaskCategory.design;

      expect(identical(cat1, cat2), true);
    });

    test('should find all categories in all list', () {
      final all = TaskCategory.all;

      expect(all.contains(TaskCategory.design), true);
      expect(all.contains(TaskCategory.dev), true);
      expect(all.contains(TaskCategory.marketing), true);
      expect(all.contains(TaskCategory.research), true);
      expect(all.contains(TaskCategory.bug), true);
      expect(all.contains(TaskCategory.general), true);
      expect(all.contains(TaskCategory.meeting), true);
    });

    test('all categories should have unique ids', () {
      final all = TaskCategory.all;
      final ids = all.map((c) => c.id).toSet();

      expect(ids.length, all.length);
    });
  });
}
