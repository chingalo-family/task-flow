import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/app_state/team_state/team_state.dart';
import 'package:task_flow/app_state/user_list_state/user_list_state.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/core/utils/utils.dart';
import 'package:task_flow/modules/teams/components/team_card.dart';
import 'package:task_flow/modules/teams/dialogs/create_team_dialog.dart';

class TeamsPage extends StatefulWidget {
  const TeamsPage({super.key});

  @override
  State<TeamsPage> createState() => _TeamsPageState();
}

class _TeamsPageState extends State<TeamsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TeamState>(context, listen: false).initialize();
      Provider.of<UserListState>(context, listen: false).initialize();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.darkBackground,
      body: SafeArea(
        child: Consumer<TeamState>(
          builder: (context, teamState, child) {
            if (teamState.loading) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppConstant.primaryBlue,
                ),
              );
            }

            // Filter teams based on search query
            final filteredTeams = teamState.teams.where((team) {
              if (_searchQuery.isEmpty) return true;
              final query = _searchQuery.toLowerCase();
              final name = team.name.toLowerCase();
              final id = team.id.toLowerCase();
              return name.contains(query) || id.contains(query);
            }).toList();

            return CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  floating: true,
                  backgroundColor: AppConstant.darkBackground,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  title: Text(
                    'My Teams',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppConstant.textPrimary,
                    ),
                  ),
                ),

                // Search Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppConstant.spacing16,
                      vertical: AppConstant.spacing8,
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppConstant.spacing16,
                        vertical: AppConstant.spacing12,
                      ),
                      decoration: BoxDecoration(
                        color: AppConstant.cardBackground,
                        borderRadius: BorderRadius.circular(
                          AppConstant.borderRadius12,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: AppConstant.textSecondary,
                            size: 20,
                          ),
                          SizedBox(width: AppConstant.spacing12),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              style: TextStyle(color: AppConstant.textPrimary),
                              decoration: InputDecoration(
                                hintText: 'Search by name or ID',
                                hintStyle: TextStyle(
                                  color: AppConstant.textSecondary,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Team List
                filteredTeams.isEmpty
                    ? SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.people_outline,
                                size: 80,
                                color: AppConstant.textSecondary.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                              SizedBox(height: AppConstant.spacing16),
                              Text(
                                _searchQuery.isEmpty
                                    ? 'No teams yet'
                                    : 'No teams found',
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      color: AppConstant.textSecondary,
                                    ),
                              ),
                              SizedBox(height: AppConstant.spacing8),
                              Text(
                                _searchQuery.isEmpty
                                    ? 'Create a team to start collaborating'
                                    : 'Try a different search term',
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    : SliverPadding(
                        padding: EdgeInsets.all(AppConstant.spacing16),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final team = filteredTeams[index];
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: AppConstant.spacing12,
                              ),
                              child: TeamCard(team: team),
                            );
                          }, childCount: filteredTeams.length),
                        ),
                      ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateTeamDialog,
        backgroundColor: AppConstant.primaryBlue,
        child: Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  void _showCreateTeamDialog() async {
    final result = await AppModalUtil.showActionSheetModal(
      context: context,
      actionSheetContainer: CreateTeamDialog(),
      maxHeightRatio: 0.95,
      initialHeightRatio: 0.95,
    );

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Team created successfully'),
          backgroundColor: AppConstant.successGreen,
        ),
      );
    }
  }
}
