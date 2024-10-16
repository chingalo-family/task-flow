import 'package:flutter/material.dart';

class AppPopUpMenuItem {
  String id;
  String name;
  IconData icon;

  AppPopUpMenuItem({required this.id, required this.name, required this.icon});

  @override
  String toString() {
    return 'item : $name';
  }

  static List<AppPopUpMenuItem> getPopUpMenuItems() {
    return [
      AppPopUpMenuItem(
          id: 'about',
          name: 'About',
          icon: Icons.info), //TODO add module for the app
    ];
  }
}
