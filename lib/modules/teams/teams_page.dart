import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/app_state/team_state/team_state.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/modules/teams/components/team_card.dart';

class TeamsPage extends StatefulWidget {
  const TeamsPage({super.key});

  @override
  State<TeamsPage> createState() => _TeamsPageState();
}

class _TeamsPageState extends State<TeamsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TeamState>(context, listen: false).initialize();
    });
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

            return CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  floating: true,
                  backgroundColor: AppConstant.darkBackground,
                  elevation: 0,
                  title: Row(
                    children: [
                      Icon(
                        Icons.people_rounded,
                        color: AppConstant.primaryBlue,
                        size: 24,
                      ),
                      SizedBox(width: AppConstant.spacing8),
                      Text(
                        'Teams',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(AppConstant.spacing24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Collaborate & Achieve',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        SizedBox(height: AppConstant.spacing8),
                        Text(
                          'You\'re part of ${teamState.totalTeams} teams',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),

                // Team List
                teamState.teams.isEmpty
                    ? SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.people_outline,
                                size: 80,
                                color: AppConstant.textSecondary.withOpacity(0.3),
                              ),
                              SizedBox(height: AppConstant.spacing16),
                              Text(
                                'No teams yet',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: AppConstant.textSecondary,
                                ),
                              ),
                              SizedBox(height: AppConstant.spacing8),
                              Text(
                                'Create a team to start collaborating',
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
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final team = teamState.teams[index];
                              return Padding(
                                padding: EdgeInsets.only(bottom: AppConstant.spacing12),
                                child: TeamCard(team: team),
                              );
                            },
                            childCount: teamState.teams.length,
                          ),
                        ),
                      ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to create team page
        },
        backgroundColor: AppConstant.primaryBlue,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
