import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app_state/app_theme_state/app_theme_state.dart';
import 'package:task_manager/core/constants/app_contant.dart';
import 'package:task_manager/models/app_pop_up_menu_item.dart';
import 'package:task_manager/modules/about/about.dart';

class AppPopUpMenu extends StatelessWidget {
  final String currentPage;

  const AppPopUpMenu({Key? key, this.currentPage = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppThemeState appThemeState =
        Provider.of<AppThemeState>(context, listen: false);
    List<AppPopUpMenuItem> menuItems = AppPopUpMenuItem.getPopUpMenuItems();
    menuItems = menuItems
        .where((AppPopUpMenuItem menuItem) =>
            menuItem.id != appThemeState.currentTheme)
        .toList();
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
        } else {
          Timer(
            const Duration(milliseconds: 100),
            () {
              appThemeState.setCurrentTheme(menuItem.id);
            },
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
                    Consumer<AppThemeState>(
                      builder: (context, appThemeState, child) {
                        return Icon(
                          menuItem.icon,
                          color: appThemeState.currentTheme == 'dark'
                              ? AppContant.darkTextColor
                              : AppContant.ligthTextColor,
                        );
                      },
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
