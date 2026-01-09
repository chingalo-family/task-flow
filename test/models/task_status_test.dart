import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_flow/core/models/task_status.dart';

void main() {
  group('TaskStatus', () {
    test('should create task status with required fields', () {
      final status = TaskStatus(
        id: 'status1',
        name: 'In Review',
        color: Colors.orange,
      );

      expect(status.id, 'status1');
      expect(status.name, 'In Review');
      expect(status.color, Colors.orange);
      expect(status.order, 0);
      expect(status.isDefault, false);
    });

    test('should create task status with all fields', () {
      final status = TaskStatus(
        id: 'status1',
        name: 'In Review',
        color: Colors.orange,
        order: 5,
        isDefault: true,
      );

      expect(status.id, 'status1');
      expect(status.name, 'In Review');
      expect(status.color, Colors.orange);
      expect(status.order, 5);
      expect(status.isDefault, true);
    });

    test('should copy status with updated fields', () {
      final original = TaskStatus(
        id: 'status1',
        name: 'Original',
        color: Colors.blue,
      );

      final copied = original.copyWith(
        name: 'Updated',
        order: 10,
      );

      expect(copied.id, 'status1');
      expect(copied.name, 'Updated');
      expect(copied.color, Colors.blue);
      expect(copied.order, 10);
    });

    test('should copy status without changes', () {
      final original = TaskStatus(
        id: 'status1',
        name: 'Test',
        color: Colors.green,
        order: 3,
      );

      final copied = original.copyWith();

      expect(copied.id, original.id);
      expect(copied.name, original.name);
      expect(copied.color, original.color);
      expect(copied.order, original.order);
    });

    test('should serialize to JSON correctly', () {
      final status = TaskStatus(
        id: 'status1',
        name: 'In Review',
        color: const Color(0xFF2E90FA),
        order: 2,
        isDefault: false,
      );

      final json = status.toJson();

      expect(json['id'], 'status1');
      expect(json['name'], 'In Review');
      expect(json['color'], 0xFF2E90FA);
      expect(json['order'], 2);
      expect(json['isDefault'], false);
    });

    test('should deserialize from JSON correctly', () {
      final json = {
        'id': 'status1',
        'name': 'In Review',
        'color': 0xFF2E90FA,
        'order': 2,
        'isDefault': false,
      };

      final status = TaskStatus.fromJson(json);

      expect(status.id, 'status1');
      expect(status.name, 'In Review');
      expect(status.color, const Color(0xFF2E90FA));
      expect(status.order, 2);
      expect(status.isDefault, false);
    });

    test('should handle missing optional fields in fromJson', () {
      final json = {
        'id': 'status1',
        'name': 'Test',
        'color': 0xFF2E90FA,
      };

      final status = TaskStatus.fromJson(json);

      expect(status.id, 'status1');
      expect(status.name, 'Test');
      expect(status.order, 0);
      expect(status.isDefault, false);
    });

    test('should get default statuses', () {
      final statuses = TaskStatus.getDefaultStatuses();

      expect(statuses.length, 3);
      expect(statuses[0].id, 'todo');
      expect(statuses[0].name, 'To Do');
      expect(statuses[0].isDefault, true);
      expect(statuses[0].order, 0);

      expect(statuses[1].id, 'in_progress');
      expect(statuses[1].name, 'In Progress');
      expect(statuses[1].isDefault, true);
      expect(statuses[1].order, 1);

      expect(statuses[2].id, 'completed');
      expect(statuses[2].name, 'Completed');
      expect(statuses[2].isDefault, true);
      expect(statuses[2].order, 2);
    });

    test('default statuses should have correct colors', () {
      final statuses = TaskStatus.getDefaultStatuses();

      expect(statuses[0].color, const Color(0xFF6B7280)); // Gray
      expect(statuses[1].color, const Color(0xFF2E90FA)); // Blue
      expect(statuses[2].color, const Color(0xFF10B981)); // Green
    });

    test('should round-trip through JSON serialization', () {
      final original = TaskStatus(
        id: 'custom1',
        name: 'Custom Status',
        color: const Color(0xFFFF5733),
        order: 7,
        isDefault: false,
      );

      final json = original.toJson();
      final deserialized = TaskStatus.fromJson(json);

      expect(deserialized.id, original.id);
      expect(deserialized.name, original.name);
      expect(deserialized.color, original.color);
      expect(deserialized.order, original.order);
      expect(deserialized.isDefault, original.isDefault);
    });
  });
}
