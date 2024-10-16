import 'package:flutter/material.dart';
import 'package:task_manager/core/components/material_card.dart';
import 'package:task_manager/core/constants/app_contant.dart';
import 'package:task_manager/models/user_group.dart';

class UserGroupListContainer extends StatelessWidget {
  const UserGroupListContainer({
    super.key,
    required this.userGroup,
    this.onAddUser,
  });

  final UserGroup userGroup;
  final VoidCallback? onAddUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 5.0,
      ),
      child: Card(
        child: ListTile(
          isThreeLine: true,
          iconColor: AppContant.defaultAppColor.withOpacity(0.5),
          title: Text(
            userGroup.name,
          ),
          onTap: () => {},
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userGroup.groupMemberCount,
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 3.0,
                ),
                child: Text(
                  'Owned by ${userGroup.createdBy}',
                  style: const TextStyle().copyWith(
                    fontSize: 11.0,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              MaterialCard(
                elevation: 2.0,
                borderRadius: 10.0,
                body: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                  child: InkWell(
                    onTap: onAddUser,
                    child: Container(
                      margin: const EdgeInsets.all(10.0),
                      child: const Icon(
                        Icons.add,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
