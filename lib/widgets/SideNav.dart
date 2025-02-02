import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/permissions.dart';

class SideNav extends StatelessWidget {
  final String role;
  final User user;

  SideNav({required this.role, required this.user});

  @override
  Widget build(BuildContext context) {
    List<dynamic> menuItems = getUserPermissions(role);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              this.user.email.toString(),
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ...menuItems.map((item) => buildMenuItem(item, context)).toList(),
        ],
      ),
    );
  }

  Widget buildMenuItem(dynamic item, BuildContext context) {
    if (item.containsKey("options")) {
      // If the item has sub-options, show an expandable menu
      return ExpansionTile(
        title: Text(item["name"]),
        children: item["options"]
            .map<Widget>((subItem) => ListTile(
          title: Text(subItem["name"]),
          onTap: () {
            // Handle navigation here
          },
        ))
            .toList(),
      );
    } else {
      // If it's a single item, show a normal ListTile
      return ListTile(
        title: Text(item["name"]),
        onTap: () {
          // Handle navigation here
        },
      );
    }
  }
}
