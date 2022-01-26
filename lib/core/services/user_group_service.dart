import 'dart:convert';

import 'package:task_manager/core/offline_db/user_offline_provider/user_group_member_offline_provider.dart';
import 'package:task_manager/core/offline_db/user_offline_provider/user_group_offline_provider.dart';
import 'package:task_manager/core/services/http_service.dart';
import 'package:task_manager/models/user_group.dart';
import 'package:task_manager/models/user_group_member.dart';

class UserGroupService {
  Future<UserGroup?> getUserGroupById({
    required String username,
    required String password,
    required String userGroupId,
  }) async {
    UserGroup? userGroups;
    try {
      if (userGroupId.isNotEmpty) {
        var url = 'api/userGroups/$userGroupId.json';
        var queryParameters = {
          'fields': 'id,name,users[id,name,username]',
        };
        HttpService http = new HttpService(
          username: username,
          password: password,
        );
        var response = await http.httpGet(url, queryParameters: queryParameters);
        if (response.statusCode == 200) {
          userGroups = UserGroup.fromJson(json.decode(response.body));
        }
      }
      return userGroups;
    } catch (error) {
      throw error;
    }
  }

  setUserGroups(List<UserGroup> userGroups) async {
    if (userGroups.isNotEmpty) {
      List<UserGroupMember> userGroupMembers =
          userGroups.expand((UserGroup userGroup) => userGroup.groupMembers).toList();
      await UserGroupOfflineProvider().addOrUpdateUserGroup(userGroups);
      if (userGroupMembers.isNotEmpty) {
        await UserGroupMemberOfflineProvider().addOrUpdateUserGroupMember(userGroupMembers);
      }
    }
  }

  Future<List<UserGroup>> getUserGroupsByUserId({
    required String userId,
  }) async {
    List<UserGroupMember> userGroupMembers =
        await UserGroupMemberOfflineProvider().getUserGroupMembersByUser(userId);
    List<String> groupIds =
        userGroupMembers.map((UserGroupMember userGroupMember) => userGroupMember.groupId).toList();
    List<UserGroup> userGroups = await UserGroupOfflineProvider().getUserGroups();
    return userGroups
        .where((UserGroup userGroup) => groupIds.contains(userGroup.id))
        .toList()
        .map((UserGroup userGroup) {
      userGroup.groupMembers = userGroupMembers
          .where((UserGroupMember userGroupMembe) => userGroupMembe.groupId == userGroup.id)
          .toList();
      return userGroup;
    }).toList();
  }
}
