import 'package:flutter/material.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/core/models/task.dart';
import 'package:task_flow/modules/tasks/components/task_card.dart';

class TaskSearchDelegate extends SearchDelegate<Task?> {
  final List<Task> tasks;

  TaskSearchDelegate(this.tasks);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: AppConstant.darkBackground,
        elevation: 0,
        iconTheme: IconThemeData(color: AppConstant.textPrimary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: AppConstant.textSecondary),
        border: InputBorder.none,
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(color: AppConstant.textPrimary, fontSize: 18),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = tasks.where((task) {
      final queryLower = query.toLowerCase();
      return task.title.toLowerCase().contains(queryLower) ||
          (task.description?.toLowerCase().contains(queryLower) ?? false) ||
          (task.category?.toLowerCase().contains(queryLower) ?? false);
    }).toList();

    if (results.isEmpty) {
      return Container(
        color: AppConstant.darkBackground,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 64,
                color: AppConstant.textSecondary.withValues(alpha: 0.3),
              ),
              SizedBox(height: AppConstant.spacing16),
              Text(
                'No tasks found',
                style: TextStyle(
                  color: AppConstant.textSecondary,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      color: AppConstant.darkBackground,
      child: ListView.builder(
        padding: EdgeInsets.all(AppConstant.spacing16),
        itemCount: results.length,
        itemBuilder: (context, index) {
          final task = results[index];
          return Padding(
            padding: EdgeInsets.only(bottom: AppConstant.spacing12),
            child: TaskCard(task: task),
          );
        },
      ),
    );
  }
}
