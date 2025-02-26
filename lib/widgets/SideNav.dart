import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../utils/permissions.dart';

class SideNav extends StatelessWidget {
  final String role;
  final User user;
  final Function(String) onMenuSelected;
  final AuthService _authService = AuthService();

  SideNav({required this.role, required this.user, required this.onMenuSelected});

  @override
  Widget build(BuildContext context) {
    List<dynamic> menuItems = getUserPermissions(role);

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.green),
            accountName: Text(
              user.displayName ?? "User",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            accountEmail: Text(
              user.email.toString(),
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.green),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: menuItems.map((item) => buildMenuItem(item, context)).toList(),
            ),
          ),
          Divider(), // Adds a separator before the logout button
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () => handleLogout(context), // Calls logout function
          ),
        ],
      ),
    );
  }

  Widget buildMenuItem(dynamic item, BuildContext context) {
    if (item.containsKey("options") && item["options"] is List) {
      // Recursively build nested menu
      return ExpansionTile(
        title: Text(item["name"]),
        children: item["options"]
            .map<Widget>((subItem) => buildMenuItem(subItem, context))
            .toList(),
      );
    } else {
      return ListTile(
        title: Text(item["name"]),
        onTap: () {
          onMenuSelected(item["name"]);
          Navigator.pop(context);
        },
      );
    }
  }

  void handleLogout(BuildContext context) async {
    try {
      await _authService.signOut();
      Navigator.of(context).pushReplacementNamed('/login'); // Redirect to login screen
    } catch (e) {
      print("Logout Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to log out. Please try again.')),
      );
    }
  }
}
