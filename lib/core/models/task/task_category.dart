import 'package:flutter/material.dart';
import 'package:task_flow/core/constants/app_constant.dart';

class TaskCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  const TaskCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  static const design = TaskCategory(
    id: 'design',
    name: 'Design',
    icon: Icons.edit,
    color: Color(0xFF8B5CF6), // Purple
  );

  static const dev = TaskCategory(
    id: 'dev',
    name: 'Dev',
    icon: Icons.code,
    color: Color(0xFF2E90FA), // Blue
  );

  static const marketing = TaskCategory(
    id: 'marketing',
    name: 'Mktg',
    icon: Icons.campaign,
    color: Color(0xFFF59E0B), // Orange
  );

  static const research = TaskCategory(
    id: 'research',
    name: 'Rsrch',
    icon: Icons.science,
    color: Color(0xFF06B6D4), // Cyan
  );

  static const bug = TaskCategory(
    id: 'bug',
    name: 'Bug',
    icon: Icons.bug_report,
    color: Color(0xFFEF4444), // Red
  );

  static const general = TaskCategory(
    id: 'general',
    name: 'General',
    icon: Icons.task_alt,
    color: Color(0xFF10B981), // Green
  );

  static const meeting = TaskCategory(
    id: 'meeting',
    name: 'Meeting',
    icon: Icons.groups,
    color: Color(0xFF14B8A6), // Teal
  );

  static List<TaskCategory> get all => [
        design,
        dev,
        marketing,
        research,
        bug,
        general,
        meeting,
      ];

  static TaskCategory? fromId(String? id) {
    if (id == null) return null;
    try {
      return all.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  static TaskCategory getById(String? id) {
    return fromId(id) ?? general;
  }
}
