import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../widgets/AddEditUserDialog.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref("users");
  final DatabaseReference _departmentsDb = FirebaseDatabase.instance.ref("departments");
  final DatabaseReference _rolesDb = FirebaseDatabase.instance.ref("roles");
  final DatabaseReference _locationsDb = FirebaseDatabase.instance.ref("locations");

  List<Map<String, String>> users = [];
  List<String> departments = [];
  List<String> roles = [];
  List<String> locations = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    _fetchDepartments();
    _fetchRoles();
    _fetchLocations();
  }

  // Fetch users from Firebase Realtime Database
  void _fetchUsers() {
    _database.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          users = data.entries.map((entry) {
            final user = Map<String, dynamic>.from(entry.value);
            return {
              "id": entry.key.toString(),
              "firstName": user["firstName"]?.toString() ?? "",
              "lastName": user["lastName"]?.toString() ?? "",
              "username": user["username"]?.toString() ?? "",
              "email": user["email"]?.toString() ?? "",
              "phone": user["phone"]?.toString() ?? "",
              "department": user["department"]?.toString() ?? "",
              "role": user["role"]?.toString() ?? "",
              "location": user["location"]?.toString() ?? "",
              "status": user["status"]?.toString() ?? "Active",
            };
          }).toList().cast<Map<String, String>>();
        });
      }
    });
  }

  // Fetch departments from Firebase
  void _fetchDepartments() {
    _departmentsDb.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          departments = data.entries.map((entry) => entry.value["name"].toString()).toList();
        });
      }
    });
  }

  // Fetch roles from Firebase
  void _fetchRoles() {
    _rolesDb.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          roles = data.entries.map((entry) => entry.value["name"].toString()).toList();
        });
      }
    });
  }

  // Fetch locations from Firebase
  void _fetchLocations() {
    _locationsDb.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          locations = data.entries.map((entry) => entry.value["name"].toString()).toList();
        });
      }
    });
  }

  // Open Add User dialog
  void _openAddUserDialog() {
    showDialog(
      context: context,
      builder: (context) => AddEditUserDialog(
        // departments: departments,
        // roles: roles,
        // locations: locations,
        onUserUpdated: _fetchUsers,
      ),
    );
  }

  // Open Edit User dialog
  void _openEditUserDialog(Map<String, String> user) {
    showDialog(
      context: context,
      builder: (context) => AddEditUserDialog(
        user: user,
        // departments: departments,
        // roles: roles,
        // locations: locations,
        onUserUpdated: _fetchUsers,
      ),
    );
  }

  // Delete user from Firebase
  void _deleteUser(String userId) {
    _database.child(userId).remove().then((_) {
      setState(() {
        users.removeWhere((user) => user["id"] == userId);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Users")),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];

            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(user["firstName"]! + " " + user["lastName"]!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Email: ${user["email"]}"),
                    Text("Phone: ${user["phone"]}"),
                    Text("Department: ${user["department"]}"),
                    Text("Role: ${user["role"]}"),
                    Text("Location: ${user["location"]}"),
                    Text("Status: ${user["status"]}"),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _openEditUserDialog(user),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteUser(user["id"]!),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddUserDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
