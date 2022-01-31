import 'package:flutter/material.dart';
import 'package:task_manager/core/components/material_card.dart';
import 'package:task_manager/core/constants/app_contant.dart';
import 'package:task_manager/core/services/theme_service.dart';
import 'package:task_manager/models/user_group.dart';

class UserGroupListContainer extends StatelessWidget {
  const UserGroupListContainer({
    Key? key,
    required this.currentTheme,
    required this.userGroup,
    this.onAddUser,
  }) : super(key: key);

  final String currentTheme;
  final UserGroup userGroup;
  final VoidCallback? onAddUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 5.0,
      ),
      child: Card(
        child: ListTile(
          isThreeLine: false,
          iconColor: currentTheme == ThemeServices.darkTheme
              ? AppContant.darkTextColor
              : AppContant.ligthTextColor,
          textColor: currentTheme == ThemeServices.darkTheme
              ? AppContant.darkTextColor
              : AppContant.ligthTextColor,
          title: Text(
            userGroup.name,
          ),
          onTap: () => {},
          subtitle: Text('Total Member ${userGroup.groupMemberCount}'),
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
                      child: Icon(
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
