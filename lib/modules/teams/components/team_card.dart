import 'package:flutter/material.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/core/models/models.dart';
import 'package:task_flow/modules/teams/pages/team_detail_page.dart';

class TeamCard extends StatelessWidget {
  final Team team;

  const TeamCard({super.key, required this.team});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppConstant.cardBackground,
        borderRadius: BorderRadius.circular(AppConstant.borderRadius16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppConstant.borderRadius16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TeamDetailPage(team: team),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(AppConstant.spacing16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Team Header
                Row(
                  children: [
                    // Team Avatar
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppConstant.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.people_rounded,
                        color: AppConstant.primaryBlue,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: AppConstant.spacing12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            team.name,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${team.memberCount} ${team.memberCount == 1 ? 'member' : 'members'}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: AppConstant.textSecondary,
                      size: 20,
                    ),
                  ],
                ),

                // Description
                if (team.description != null && team.description!.isNotEmpty) ...[
                  SizedBox(height: AppConstant.spacing12),
                  Text(
                    team.description!,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                // Member Avatars
                if (team.memberIds != null && team.memberIds!.isNotEmpty) ...[
                  SizedBox(height: AppConstant.spacing16),
                  Row(
                    children: [
                      // Show up to 5 member avatars
                      ...team.memberIds!.take(5).map((memberId) {
                        final index = team.memberIds!.indexOf(memberId);
                        return Container(
                          margin: EdgeInsets.only(
                            right: index < 4 && index < team.memberIds!.length - 1
                                ? 8
                                : 0,
                          ),
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: _getAvatarColor(index),
                            child: Text(
                              _getInitials(index),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      
                      // Show +N if there are more members
                      if (team.memberCount > 5) ...[
                        SizedBox(width: 8),
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: AppConstant.textSecondary.withOpacity(0.2),
                          child: Text(
                            '+${team.memberCount - 5}',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppConstant.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getAvatarColor(int index) {
    final colors = [
      AppConstant.primaryBlue,
      AppConstant.successGreen,
      AppConstant.warningOrange,
      Color(0xFF9B59B6), // Purple
      Color(0xFF3498DB), // Light Blue
    ];
    return colors[index % colors.length];
  }

  String _getInitials(int index) {
    final names = ['JD', 'KL', 'SM', 'MJ', 'LC'];
    return names[index % names.length];
  }
}
