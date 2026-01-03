import 'package:flutter/material.dart';

class TaskStatus {
  final String id;
  final String name;
  final Color color;
  final int order;
  final bool isDefault;

  TaskStatus({
    required this.id,
    required this.name,
    required this.color,
    this.order = 0,
    this.isDefault = false,
  });

  TaskStatus copyWith({
    String? id,
    String? name,
    Color? color,
    int? order,
    bool? isDefault,
  }) {
    return TaskStatus(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      order: order ?? this.order,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color.toARGB32(),
      'order': order,
      'isDefault': isDefault,
    };
  }

  factory TaskStatus.fromJson(Map<String, dynamic> json) {
    return TaskStatus(
      id: json['id'] as String,
      name: json['name'] as String,
      color: Color(json['color'] as int),
      order: json['order'] as int? ?? 0,
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

  // Default task statuses
  static List<TaskStatus> getDefaultStatuses() {
    return [
      TaskStatus(
        id: 'todo',
        name: 'To Do',
        color: const Color(0xFF6B7280), // Gray
        order: 0,
        isDefault: true,
      ),
      TaskStatus(
        id: 'in_progress',
        name: 'In Progress',
        color: const Color(0xFF2E90FA), // Blue
        order: 1,
        isDefault: true,
      ),
      TaskStatus(
        id: 'completed',
        name: 'Completed',
        color: const Color(0xFF10B981), // Green
        order: 2,
        isDefault: true,
      ),
    ];
  }
}
