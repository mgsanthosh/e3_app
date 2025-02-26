import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../widgets/AddEditRoleDialog.dart'; // You'll create this dialog widget

class RoleScreen extends StatefulWidget {
  @override
  _RoleScreenState createState() => _RoleScreenState();
}

class _RoleScreenState extends State<RoleScreen> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref("roles");

  List<Map<String, String>> roles = [];

  @override
  void initState() {
    super.initState();
    _fetchRoles();
  }

  void _fetchRoles() {
    _database.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          roles = data.entries.map((entry) {
            final role = Map<String, dynamic>.from(entry.value);
            return {
              "id": entry.key.toString(),
              "name": role["name"]?.toString() ?? "",
              "description": role["description"]?.toString() ?? "",
              "status": role["status"]?.toString() ?? "Active",
            };
          }).toList().cast<Map<String, String>>();
        });
      }
    });
  }

  void _openAddRoleDialog() {
    showDialog(
      context: context,
      builder: (context) => AddEditRoleDialog(onRoleUpdated: _fetchRoles),
    );
  }

  void _openEditRoleDialog(Map<String, String> role) {
    showDialog(
      context: context,
      builder: (context) => AddEditRoleDialog(
        role: role,
        onRoleUpdated: _fetchRoles,
      ),
    );
  }

  void _deleteRole(String roleId) {
    _database.child(roleId).remove().then((_) {
      setState(() {
        roles.removeWhere((role) => role["id"] == roleId);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color(0xFFF1F6EB),
      //appBar: AppBar(title: Text("Roles")),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: roles.length,
          itemBuilder: (context, index) {
            final role = roles[index];

            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(role["name"]!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Description: ${role["description"]}"),
                    Text("Status: ${role["status"]}"),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _openEditRoleDialog(role),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteRole(role["id"]!),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: _openAddRoleDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
