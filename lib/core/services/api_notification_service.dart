import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:task_flow/core/constants/api_config.dart';
import 'package:task_flow/core/models/notification.dart' as model;
import 'package:task_flow/core/services/task_flow_api_service.dart';
import 'package:task_flow/core/services/notification_service.dart';

/// API Notification Service
/// 
/// Handles notification operations with the backend API
/// Falls back to local NotificationService for offline support
class ApiNotificationService {
  final TaskFlowApiService _api = TaskFlowApiService();
  final NotificationService _localService = NotificationService();

  ApiNotificationService._();
  static final ApiNotificationService _instance = ApiNotificationService._();
  factory ApiNotificationService() => _instance;

  /// Get all notifications from the server
  Future<List<model.Notification>> getAllNotifications() async {
    try {
      final response = await _api.get(ApiConfig.notificationsEndpoint);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> notificationsJson = data['notifications'] ?? data;
        
        final notifications = notificationsJson
            .map((json) => _notificationFromJson(json))
            .toList();
        
        // Update local storage
        for (var notification in notifications) {
          await _localService.createNotification(notification);
        }
        
        return notifications;
      }
      
      return await _localService.getAllNotifications();
    } catch (e) {
      debugPrint('API get all notifications error: $e');
      return await _localService.getAllNotifications();
    }
  }

  /// Get unread notifications
  Future<List<model.Notification>> getUnreadNotifications() async {
    try {
      final response = await _api.get(
        ApiConfig.notificationsEndpoint,
        queryParameters: {'unread': 'true'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> notificationsJson = data['notifications'] ?? data;
        
        return notificationsJson
            .map((json) => _notificationFromJson(json))
            .toList();
      }
      
      return await _localService.getUnreadNotifications();
    } catch (e) {
      debugPrint('API get unread notifications error: $e');
      return await _localService.getUnreadNotifications();
    }
  }

  /// Mark a notification as read
  Future<bool> markAsRead(String id) async {
    try {
      final response = await _api.patch(
        '${ApiConfig.notificationsEndpoint}/$id',
        body: {'isRead': true},
      );

      if (response.statusCode == 200) {
        // Update local storage
        final notification = await _localService.getNotificationById(id);
        if (notification != null) {
          final updatedNotification = notification.copyWith(isRead: true);
          await _localService.updateNotification(updatedNotification);
        }
        return true;
      }
      
      return false;
    } catch (e) {
      debugPrint('API mark notification as read error: $e');
      return false;
    }
  }

  /// Mark all notifications as read
  Future<bool> markAllAsRead() async {
    try {
      final response = await _api.patch(
        ApiConfig.notificationsEndpoint,
        body: {'markAllAsRead': true},
      );

      if (response.statusCode == 200) {
        // Update local storage
        final notifications = await _localService.getAllNotifications();
        for (var notification in notifications) {
          if (!notification.isRead) {
            final updatedNotification = notification.copyWith(isRead: true);
            await _localService.updateNotification(updatedNotification);
          }
        }
        return true;
      }
      
      return false;
    } catch (e) {
      debugPrint('API mark all notifications as read error: $e');
      return false;
    }
  }

  /// Delete a notification
  Future<bool> deleteNotification(String id) async {
    try {
      final response = await _api.delete(
        '${ApiConfig.notificationsEndpoint}/$id',
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Delete from local storage
        await _localService.deleteNotification(id);
        return true;
      }
      
      return false;
    } catch (e) {
      debugPrint('API delete notification error: $e');
      return await _localService.deleteNotification(id);
    }
  }

  /// Send a notification (for server-side processing)
  Future<bool> sendNotification({
    required String type,
    required String title,
    required String message,
    String? taskId,
    String? teamId,
    String? userId,
  }) async {
    try {
      final response = await _api.post(
        ApiConfig.notificationsEndpoint,
        body: {
          'type': type,
          'title': title,
          'message': message,
          if (taskId != null) 'taskId': taskId,
          if (teamId != null) 'teamId': teamId,
          if (userId != null) 'userId': userId,
        },
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      debugPrint('API send notification error: $e');
      return false;
    }
  }

  /// Convert JSON from API to Notification model
  model.Notification _notificationFromJson(Map<String, dynamic> json) {
    return model.Notification(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? json['message'],
      type: json['type'] ?? 'general',
      isRead: json['isRead'] ?? false,
      relatedEntityId: json['relatedEntityId'] ?? json['taskId'] ?? json['teamId'],
      relatedEntityType: json['relatedEntityType'],
      actorUserId: json['actorUserId'] ?? json['userId'],
      actorUsername: json['actorUsername'],
      actorAvatarUrl: json['actorAvatarUrl'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}
