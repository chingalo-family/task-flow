import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:task_flow/core/constants/api_config.dart';
import 'package:task_flow/core/models/task.dart';
import 'package:task_flow/core/services/task_flow_api_service.dart';
import 'package:task_flow/core/services/task_service.dart';

/// API Task Service
/// 
/// Handles task operations with the backend API
/// Falls back to local TaskService for offline support
class ApiTaskService {
  final TaskFlowApiService _api = TaskFlowApiService();
  final TaskService _localService = TaskService();

  ApiTaskService._();
  static final ApiTaskService _instance = ApiTaskService._();
  factory ApiTaskService() => _instance;

  /// Create a new task on the server
  Future<Task?> createTask(Task task) async {
    try {
      // Convert Task to JSON
      final taskJson = _taskToJson(task);
      
      final response = await _api.post(
        ApiConfig.tasksEndpoint,
        body: taskJson,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        final createdTask = _taskFromJson(data);
        
        // Save to local storage for offline access
        await _localService.createTask(createdTask);
        
        return createdTask;
      }
      
      return null;
    } catch (e) {
      debugPrint('API create task error: $e');
      // Fall back to local creation
      return await _localService.createTask(task);
    }
  }

  /// Get all tasks from the server
  Future<List<Task>> getAllTasks() async {
    try {
      final response = await _api.get(ApiConfig.tasksEndpoint);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> tasksJson = data['tasks'] ?? data;
        
        final tasks = tasksJson.map((json) => _taskFromJson(json)).toList();
        
        // Update local storage
        for (var task in tasks) {
          await _localService.updateTask(task);
        }
        
        return tasks;
      }
      
      // Fall back to local storage
      return await _localService.getAllTasks();
    } catch (e) {
      debugPrint('API get all tasks error: $e');
      return await _localService.getAllTasks();
    }
  }

  /// Get a specific task by ID
  Future<Task?> getTaskById(String id) async {
    try {
      final response = await _api.get('${ApiConfig.tasksEndpoint}/$id');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final task = _taskFromJson(data);
        
        // Update local storage
        await _localService.updateTask(task);
        
        return task;
      }
      
      return null;
    } catch (e) {
      debugPrint('API get task by ID error: $e');
      return await _localService.getTaskById(id);
    }
  }

  /// Update a task on the server
  Future<bool> updateTask(Task task) async {
    try {
      final taskJson = _taskToJson(task);
      
      final response = await _api.put(
        '${ApiConfig.tasksEndpoint}/${task.id}',
        body: taskJson,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final updatedTask = _taskFromJson(data);
        
        // Update local storage
        await _localService.updateTask(updatedTask);
        
        return true;
      }
      
      return false;
    } catch (e) {
      debugPrint('API update task error: $e');
      // Fall back to local update
      return await _localService.updateTask(task);
    }
  }

  /// Delete a task from the server
  Future<bool> deleteTask(String id) async {
    try {
      final response = await _api.delete('${ApiConfig.tasksEndpoint}/$id');

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Delete from local storage
        await _localService.deleteTask(id);
        return true;
      }
      
      return false;
    } catch (e) {
      debugPrint('API delete task error: $e');
      // Fall back to local delete
      return await _localService.deleteTask(id);
    }
  }

  /// Get tasks by status
  Future<List<Task>> getTasksByStatus(String status) async {
    try {
      final response = await _api.get(
        ApiConfig.tasksEndpoint,
        queryParameters: {'status': status},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> tasksJson = data['tasks'] ?? data;
        
        return tasksJson.map((json) => _taskFromJson(json)).toList();
      }
      
      return await _localService.getTasksByStatus(status);
    } catch (e) {
      debugPrint('API get tasks by status error: $e');
      return await _localService.getTasksByStatus(status);
    }
  }

  /// Get tasks by priority
  Future<List<Task>> getTasksByPriority(String priority) async {
    try {
      final response = await _api.get(
        ApiConfig.tasksEndpoint,
        queryParameters: {'priority': priority},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> tasksJson = data['tasks'] ?? data;
        
        return tasksJson.map((json) => _taskFromJson(json)).toList();
      }
      
      return await _localService.getTasksByPriority(priority);
    } catch (e) {
      debugPrint('API get tasks by priority error: $e');
      return await _localService.getTasksByPriority(priority);
    }
  }

  /// Convert Task model to JSON for API
  Map<String, dynamic> _taskToJson(Task task) {
    return {
      'id': task.id,
      'title': task.title,
      'description': task.description,
      'status': task.status,
      'priority': task.priority,
      'category': task.category,
      'assignedToUserId': task.assignedToUserId,
      'assignedToUsername': task.assignedToUsername,
      'assignedUserIds': task.assignedUserIds,
      'teamId': task.teamId,
      'teamName': task.teamName,
      'dueDate': task.dueDate?.toIso8601String(),
      'completedAt': task.completedAt?.toIso8601String(),
      'projectId': task.projectId,
      'projectName': task.projectName,
      'tags': task.tags,
      'attachments': task.attachments,
      'subtasks': task.subtasks?.map((s) => {
        'id': s.id,
        'title': s.title,
        'isCompleted': s.isCompleted,
      }).toList(),
      'remindMe': task.remindMe,
      'progress': task.progress,
      'createdAt': task.createdAt.toIso8601String(),
      'updatedAt': task.updatedAt.toIso8601String(),
    };
  }

  /// Convert JSON from API to Task model
  Task _taskFromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      status: json['status'] ?? 'pending',
      priority: json['priority'] ?? 'medium',
      category: json['category'],
      assignedToUserId: json['assignedToUserId'],
      assignedToUsername: json['assignedToUsername'],
      assignedUserIds: json['assignedUserIds'] != null
          ? List<String>.from(json['assignedUserIds'])
          : null,
      teamId: json['teamId'],
      teamName: json['teamName'],
      dueDate: json['dueDate'] != null 
          ? DateTime.parse(json['dueDate'])
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      projectId: json['projectId'],
      projectName: json['projectName'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      attachments: json['attachments'] != null
          ? List<String>.from(json['attachments'])
          : null,
      subtasks: json['subtasks'] != null
          ? (json['subtasks'] as List).map((s) => Subtask(
                id: s['id']?.toString() ?? '',
                title: s['title'] ?? '',
                isCompleted: s['isCompleted'] ?? false,
              )).toList()
          : null,
      remindMe: json['remindMe'],
      progress: json['progress'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }
}
