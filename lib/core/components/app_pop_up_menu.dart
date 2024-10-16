import 'package:flutter/material.dart';
import 'package:task_manager/models/app_pop_up_menu_item.dart';
import 'package:task_manager/modules/about/about.dart';

class AppPopUpMenu extends StatelessWidget {
  final String currentPage;

  const AppPopUpMenu({super.key, this.currentPage = ''});

  @override
  Widget build(BuildContext context) {
    List<AppPopUpMenuItem> menuItems = AppPopUpMenuItem.getPopUpMenuItems();

    menuItems = currentPage != ''
        ? menuItems
            .where((AppPopUpMenuItem menuItem) => menuItem.id != currentPage)
            .toList()
        : menuItems;
    return PopupMenuButton(
      onSelected: (AppPopUpMenuItem menuItem) {
        if (menuItem.id == 'about') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const About(),
            ),
          );
        }
      },
      elevation: 4.0,
      itemBuilder: (BuildContext context) {
        return menuItems
            .map(
              (AppPopUpMenuItem menuItem) => PopupMenuItem(
                value: menuItem,
                child: Row(
                  children: [
                    Icon(
                      menuItem.icon,
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      menuItem.name,
                      style: const TextStyle().copyWith(),
                    ),
                  ],
                ),
              ),
            )
            .toList();
      },
    );
  }
}
