import 'package:flutter/material.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/core/models/models.dart';
import 'package:task_flow/modules/teams/pages/team_detail_page.dart';

class TeamCard extends StatelessWidget {
  final Team team;

  const TeamCard({super.key, required this.team});

  @override
  Widget build(BuildContext context) {
    final teamColor = _getTeamColor(team.id);
    final teamIcon = _getTeamIcon(team.name);
    final isSyncing = team.id == '2'; // Mock syncing status for demo

    return Container(
      decoration: BoxDecoration(
        color: AppConstant.cardBackground,
        borderRadius: BorderRadius.circular(AppConstant.borderRadius16),
        border: Border(left: BorderSide(color: teamColor, width: 4)),
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
                    // Team Avatar with Icon
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: teamColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(teamIcon, color: Colors.white, size: 28),
                    ),
                    SizedBox(width: AppConstant.spacing12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            team.name,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: AppConstant.textPrimary,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                'ID: #${team.id.toUpperCase()}',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      fontSize: 12,
                                      color: AppConstant.textSecondary,
                                    ),
                              ),
                              if (isSyncing) ...[
                                SizedBox(width: 8),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppConstant.warningOrange.withValues(
                                      alpha: 0.2,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.sync,
                                        size: 10,
                                        color: AppConstant.warningOrange,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'SYNCING...',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: AppConstant.warningOrange,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Show options menu
                      },
                      icon: Icon(
                        Icons.more_vert,
                        color: AppConstant.textSecondary,
                        size: 20,
                      ),
                    ),
                  ],
                ),

                // Member Avatars
                SizedBox(height: AppConstant.spacing16),
                Row(
                  children: [
                    // Show up to 3 member avatars with overlap
                    ...List.generate(
                      team.memberCount > 3 ? 3 : team.memberCount,
                      (index) {
                        return Positioned(
                          left: index * 24.0,
                          child: Container(
                            width: 32,
                            height: 32,
                            margin: EdgeInsets.only(right: index < 2 ? 0 : 8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppConstant.cardBackground,
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 14,
                              backgroundColor: _getAvatarColor(index),
                              child: Text(
                                _getInitials(index),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    // Show +N if there are more members
                    if (team.memberCount > 5) ...[
                      SizedBox(width: 8),
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: AppConstant.textSecondary.withValues(
                          alpha: 0.2,
                        ),
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
                    Spacer(),
                    Row(
                      children: [
                        Text(
                          '${team.memberCount} Member${team.memberCount != 1 ? 's' : ''}',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppConstant.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.chevron_right,
                          color: AppConstant.textSecondary,
                          size: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getTeamColor(String teamId) {
    final colors = [
      AppConstant.primaryBlue,
      Color(0xFFFF6B35), // Orange
      Color(0xFF10B981), // Green
      Color(0xFF94A3B8), // Gray
    ];
    // Use hash code for reliable color assignment with any string ID
    final hash = teamId.hashCode.abs();
    return colors[hash % colors.length];
  }

  IconData _getTeamIcon(String teamName) {
    final nameLower = teamName.toLowerCase();
    if (nameLower.contains('market')) return Icons.campaign;
    if (nameLower.contains('engineer') || nameLower.contains('tech')) {
      return Icons.code;
    }
    if (nameLower.contains('design')) return Icons.palette;
    if (nameLower.contains('product')) return Icons.rocket_launch;
    return Icons.people_rounded;
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
