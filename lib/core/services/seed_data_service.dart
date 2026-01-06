import 'package:flutter/foundation.dart';
import 'package:task_flow/core/constants/task_constants.dart';
import 'package:task_flow/core/models/models.dart';
import 'package:task_flow/core/services/preference_service.dart';
import 'package:task_flow/core/services/task_service.dart';
import 'package:task_flow/core/services/team_service.dart';
import 'package:task_flow/core/services/notification_service.dart';
import 'package:task_flow/core/offline_db/user_offline_provider/user_offline_provider.dart';
import 'package:task_flow/core/utils/utils.dart';

/// Service for prepopulating sample data on first app launch
///
/// This service creates sample notifications, tasks, teams, and users
/// to help users explore the app's features immediately.
class SeedDataService {
  SeedDataService._();
  static final SeedDataService _instance = SeedDataService._();
  factory SeedDataService() => _instance;

  final _taskService = TaskService();
  final _teamService = TeamService();
  final _notificationService = NotificationService();
  final _userOfflineProvider = UserOfflineProvider();
  final _preferenceService = PreferenceService();

  static const String _seedDataLoadedKey = 'seed_data_loaded';

  /// Check if seed data has already been loaded
  Future<bool> isSeedDataLoaded() async {
    final isLoaded = await _preferenceService.getBool(_seedDataLoadedKey);
    return isLoaded ?? false;
  }

  /// Mark seed data as loaded
  Future<void> _markSeedDataAsLoaded() async {
    await _preferenceService.setBool(_seedDataLoadedKey, true);
  }

  /// Initialize all sample data if not already loaded
  Future<void> initializeSeedData() async {
    try {
      final isLoaded = await isSeedDataLoaded();
      if (isLoaded) {
        debugPrint('Seed data already loaded, skipping initialization');
        return;
      }

      debugPrint('Initializing seed data...');

      // Create sample users first (for teams and tasks)
      final sampleUsers = await _createSampleUsers();
      
      // Create sample teams
      final sampleTeams = await _createSampleTeams(sampleUsers);
      
      // Create sample tasks (focus, upcoming, overdue)
      await _createSampleTasks(sampleUsers, sampleTeams);
      
      // Create sample notifications
      await _createSampleNotifications(sampleUsers);

      // Mark as loaded
      await _markSeedDataAsLoaded();
      
      debugPrint('Seed data initialization completed successfully');
    } catch (e) {
      debugPrint('Error initializing seed data: $e');
      // Don't mark as loaded if there was an error
    }
  }

  /// Create sample users
  Future<List<User>> _createSampleUsers() async {
    final users = [
      User(
        id: 'user_1',
        username: 'sarah_chen',
        fullName: 'Sarah Chen',
        email: 'sarah.chen@taskflow.com',
        phoneNumber: '+1-555-0101',
      ),
      User(
        id: 'user_2',
        username: 'james_wilson',
        fullName: 'James Wilson',
        email: 'james.wilson@taskflow.com',
        phoneNumber: '+1-555-0102',
      ),
      User(
        id: 'user_3',
        username: 'maria_garcia',
        fullName: 'Maria Garcia',
        email: 'maria.garcia@taskflow.com',
        phoneNumber: '+1-555-0103',
      ),
      User(
        id: 'user_4',
        username: 'david_kim',
        fullName: 'David Kim',
        email: 'david.kim@taskflow.com',
        phoneNumber: '+1-555-0104',
      ),
    ];

    for (final user in users) {
      await _userOfflineProvider.addOrUpdateUser(user);
    }

    debugPrint('Created ${users.length} sample users');
    return users;
  }

  /// Create sample teams
  Future<List<Team>> _createSampleTeams(List<User> users) async {
    final now = DateTime.now();
    
    final teams = [
      Team(
        id: 'team_1',
        name: 'Product Development',
        description: 'Building the future of task management',
        memberCount: 3,
        memberIds: [users[0].id, users[1].id, users[2].id],
        createdByUserId: users[0].id,
        createdByUsername: users[0].username,
        teamIcon: 'rocket',
        teamColor: '#2E90FA',
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
      Team(
        id: 'team_2',
        name: 'Marketing Team',
        description: 'Spreading the word about our amazing product',
        memberCount: 2,
        memberIds: [users[2].id, users[3].id],
        createdByUserId: users[2].id,
        createdByUsername: users[2].username,
        teamIcon: 'megaphone',
        teamColor: '#F79009',
        createdAt: now.subtract(const Duration(days: 20)),
        updatedAt: now.subtract(const Duration(days: 3)),
      ),
      Team(
        id: 'team_3',
        name: 'Design Studio',
        description: 'Crafting beautiful user experiences',
        memberCount: 2,
        memberIds: [users[0].id, users[3].id],
        createdByUserId: users[3].id,
        createdByUsername: users[3].username,
        teamIcon: 'palette',
        teamColor: '#7F56D9',
        createdAt: now.subtract(const Duration(days: 15)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
    ];

    for (final team in teams) {
      await _teamService.createTeam(team);
    }

    debugPrint('Created ${teams.length} sample teams');
    return teams;
  }

  /// Create sample tasks (focus, upcoming, and overdue)
  Future<void> _createSampleTasks(List<User> users, List<Team> teams) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    final tasks = [
      // Focus tasks - High priority, due today or soon
      Task(
        id: AppUtil.getUid(),
        title: 'Review product roadmap Q1',
        description: 'Review and finalize the product roadmap for Q1 2026',
        status: TaskConstants.statusInProgress,
        priority: TaskConstants.priorityHigh,
        category: TaskConstants.categoryGeneral,
        assignedUserIds: [users[0].id, users[1].id],
        assignedToUserId: users[0].id,
        assignedToUsername: users[0].username,
        teamId: teams[0].id,
        teamName: teams[0].name,
        dueDate: today.add(const Duration(hours: 18)),
        progress: 60,
        tags: ['planning', 'priority'],
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now.subtract(const Duration(hours: 2)),
      ),
      Task(
        id: AppUtil.getUid(),
        title: 'Fix critical bug in login flow',
        description: 'Users are experiencing issues with password reset',
        status: TaskConstants.statusInProgress,
        priority: TaskConstants.priorityHigh,
        category: TaskConstants.categoryBug,
        assignedUserIds: [users[1].id],
        assignedToUserId: users[1].id,
        assignedToUsername: users[1].username,
        teamId: teams[0].id,
        teamName: teams[0].name,
        dueDate: today.add(const Duration(hours: 12)),
        progress: 40,
        tags: ['urgent', 'authentication'],
        subtasks: [
          Subtask(id: 'st1', title: 'Identify root cause', isCompleted: true),
          Subtask(id: 'st2', title: 'Implement fix', isCompleted: false),
          Subtask(id: 'st3', title: 'Test fix', isCompleted: false),
        ],
        createdAt: now.subtract(const Duration(hours: 8)),
        updatedAt: now.subtract(const Duration(hours: 1)),
      ),
      Task(
        id: AppUtil.getUid(),
        title: 'Design new onboarding screens',
        description: 'Create wireframes and mockups for improved user onboarding',
        status: TaskConstants.statusPending,
        priority: TaskConstants.priorityHigh,
        category: TaskConstants.categoryDesign,
        assignedUserIds: [users[3].id],
        assignedToUserId: users[3].id,
        assignedToUsername: users[3].username,
        teamId: teams[2].id,
        teamName: teams[2].name,
        dueDate: today.add(const Duration(days: 1)),
        progress: 0,
        tags: ['design', 'ux'],
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
      
      // Upcoming tasks
      Task(
        id: AppUtil.getUid(),
        title: 'Prepare Q1 marketing campaign',
        description: 'Plan and schedule social media content for Q1',
        status: TaskConstants.statusPending,
        priority: TaskConstants.priorityMedium,
        category: TaskConstants.categoryMarketing,
        assignedUserIds: [users[2].id, users[3].id],
        assignedToUserId: users[2].id,
        assignedToUsername: users[2].username,
        teamId: teams[1].id,
        teamName: teams[1].name,
        dueDate: today.add(const Duration(days: 5)),
        progress: 0,
        tags: ['marketing', 'social-media'],
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      Task(
        id: AppUtil.getUid(),
        title: 'Conduct user research interviews',
        description: 'Interview 10 users about their experience with the app',
        status: TaskConstants.statusPending,
        priority: TaskConstants.priorityMedium,
        category: TaskConstants.categoryResearch,
        assignedUserIds: [users[0].id],
        assignedToUserId: users[0].id,
        assignedToUsername: users[0].username,
        teamId: teams[0].id,
        teamName: teams[0].name,
        dueDate: today.add(const Duration(days: 7)),
        progress: 0,
        tags: ['research', 'user-feedback'],
        subtasks: [
          Subtask(id: 'st4', title: 'Prepare interview questions', isCompleted: false),
          Subtask(id: 'st5', title: 'Schedule interviews', isCompleted: false),
          Subtask(id: 'st6', title: 'Conduct interviews', isCompleted: false),
        ],
        createdAt: now.subtract(const Duration(days: 4)),
        updatedAt: now.subtract(const Duration(days: 4)),
      ),
      Task(
        id: AppUtil.getUid(),
        title: 'Update project documentation',
        description: 'Ensure all project documentation is up to date',
        status: TaskConstants.statusPending,
        priority: TaskConstants.priorityLow,
        category: TaskConstants.categoryGeneral,
        assignedUserIds: [users[1].id],
        assignedToUserId: users[1].id,
        assignedToUsername: users[1].username,
        teamId: teams[0].id,
        teamName: teams[0].name,
        dueDate: today.add(const Duration(days: 10)),
        progress: 0,
        tags: ['documentation'],
        createdAt: now.subtract(const Duration(days: 6)),
        updatedAt: now.subtract(const Duration(days: 6)),
      ),
      
      // Overdue tasks
      Task(
        id: AppUtil.getUid(),
        title: 'Submit monthly report',
        description: 'Compile and submit the monthly team progress report',
        status: TaskConstants.statusPending,
        priority: TaskConstants.priorityHigh,
        category: TaskConstants.categoryGeneral,
        assignedUserIds: [users[0].id],
        assignedToUserId: users[0].id,
        assignedToUsername: users[0].username,
        teamId: teams[0].id,
        teamName: teams[0].name,
        dueDate: today.subtract(const Duration(days: 2)),
        progress: 70,
        tags: ['report', 'overdue'],
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now.subtract(const Duration(days: 3)),
      ),
      Task(
        id: AppUtil.getUid(),
        title: 'Review team performance',
        description: 'Conduct performance reviews for team members',
        status: TaskConstants.statusPending,
        priority: TaskConstants.priorityMedium,
        category: TaskConstants.categoryMeeting,
        assignedUserIds: [users[2].id],
        assignedToUserId: users[2].id,
        assignedToUsername: users[2].username,
        teamId: teams[1].id,
        teamName: teams[1].name,
        dueDate: today.subtract(const Duration(days: 1)),
        progress: 30,
        tags: ['hr', 'overdue'],
        createdAt: now.subtract(const Duration(days: 8)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
      
      // Completed task
      Task(
        id: AppUtil.getUid(),
        title: 'Launch new feature: Dark mode',
        description: 'Successfully deployed dark mode across all platforms',
        status: TaskConstants.statusCompleted,
        priority: TaskConstants.priorityHigh,
        category: TaskConstants.categoryDev,
        assignedUserIds: [users[1].id, users[3].id],
        assignedToUserId: users[1].id,
        assignedToUsername: users[1].username,
        teamId: teams[0].id,
        teamName: teams[0].name,
        dueDate: today.subtract(const Duration(days: 3)),
        completedAt: today.subtract(const Duration(days: 3, hours: 2)),
        progress: 100,
        tags: ['feature', 'completed'],
        createdAt: now.subtract(const Duration(days: 14)),
        updatedAt: today.subtract(const Duration(days: 3, hours: 2)),
      ),
    ];

    for (final task in tasks) {
      await _taskService.createTask(task);
    }

    debugPrint('Created ${tasks.length} sample tasks');
  }

  /// Create sample notifications
  Future<void> _createSampleNotifications(List<User> users) async {
    final now = DateTime.now();
    
    final notifications = [
      Notification(
        id: AppUtil.getUid(),
        title: 'New Task Assigned',
        body: '${users[0].fullName} assigned you to "Review product roadmap Q1"',
        type: 'task_assigned',
        isRead: false,
        actorUserId: users[0].id,
        actorUsername: users[0].username,
        relatedEntityType: 'task',
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      Notification(
        id: AppUtil.getUid(),
        title: 'Team Invitation',
        body: '${users[2].fullName} invited you to join "Marketing Team"',
        type: 'team_invite',
        isRead: false,
        actorUserId: users[2].id,
        actorUsername: users[2].username,
        relatedEntityType: 'team',
        createdAt: now.subtract(const Duration(hours: 5)),
      ),
      Notification(
        id: AppUtil.getUid(),
        title: 'Task Completed',
        body: '${users[1].fullName} completed "Launch new feature: Dark mode"',
        type: 'task_completed',
        isRead: false,
        actorUserId: users[1].id,
        actorUsername: users[1].username,
        relatedEntityType: 'task',
        createdAt: now.subtract(const Duration(days: 3, hours: 2)),
      ),
      Notification(
        id: AppUtil.getUid(),
        title: 'Task Overdue',
        body: 'Your task "Submit monthly report" is now overdue',
        type: 'task_overdue',
        isRead: false,
        relatedEntityType: 'task',
        createdAt: now.subtract(const Duration(hours: 12)),
      ),
      Notification(
        id: AppUtil.getUid(),
        title: 'New Comment',
        body: '${users[3].fullName} commented on "Design new onboarding screens"',
        type: 'comment',
        isRead: true,
        actorUserId: users[3].id,
        actorUsername: users[3].username,
        relatedEntityType: 'task',
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      Notification(
        id: AppUtil.getUid(),
        title: 'Task Due Soon',
        body: '"Fix critical bug in login flow" is due in 12 hours',
        type: 'task_due_soon',
        isRead: true,
        relatedEntityType: 'task',
        createdAt: now.subtract(const Duration(days: 1, hours: 6)),
      ),
      Notification(
        id: AppUtil.getUid(),
        title: 'New Team Member',
        body: '${users[1].fullName} joined "Product Development" team',
        type: 'team_member_joined',
        isRead: true,
        actorUserId: users[1].id,
        actorUsername: users[1].username,
        relatedEntityType: 'team',
        createdAt: now.subtract(const Duration(days: 2)),
      ),
    ];

    for (final notification in notifications) {
      await _notificationService.createNotification(notification);
    }

    debugPrint('Created ${notifications.length} sample notifications');
  }

  /// Reset seed data (for testing purposes)
  Future<void> resetSeedData() async {
    await _preferenceService.setBool(_seedDataLoadedKey, false);
    debugPrint('Seed data reset - will be reloaded on next initialization');
  }
}
