import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class AddEditUserDialog extends StatefulWidget {
  final Map<String, String>? user;
  final VoidCallback onUserUpdated;

  AddEditUserDialog({this.user, required this.onUserUpdated});

  @override
  _AddEditUserDialogState createState() => _AddEditUserDialogState();
}

class _AddEditUserDialogState extends State<AddEditUserDialog> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref("users");
  final DatabaseReference _departmentDatabase = FirebaseDatabase.instance.ref("departments");
  final DatabaseReference _roleDatabase = FirebaseDatabase.instance.ref("roles");
  final DatabaseReference _locationDatabase = FirebaseDatabase.instance.ref("locations");

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final AuthService _authService = AuthService();

  String? selectedDepartment;
  String? selectedRole;
  String? selectedLocation;
  String selectedStatus = "Active";

  List<String> departments = [];
  List<String> roles = [];
  List<String> locations = [];

  @override
  void initState() {
    super.initState();
    _fetchDepartments();
    _fetchRoles();
    _fetchLocations();

    if (widget.user != null) {
      firstNameController.text = widget.user!["firstName"]!;
      lastNameController.text = widget.user!["lastName"]!;
      usernameController.text = widget.user!["username"]!;
      emailController.text = widget.user!["email"]!;
      phoneController.text = widget.user!["phone"]!;
      selectedDepartment = widget.user!["department"];
      selectedRole = widget.user!["role"];
      selectedLocation = widget.user!["location"];
      selectedStatus = widget.user!["status"]!;
    }
  }

  void _fetchDepartments() async {
    _departmentDatabase.once().then((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          departments = data.values.map((department) => department["name"].toString()).toList();
        });
      }
    });
  }

  void _fetchRoles() async {
    _roleDatabase.once().then((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          roles = data.values.map((role) => role["name"].toString()).toList();
        });
      }
    });
  }

  void _fetchLocations() async {
    _locationDatabase.once().then((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          locations = data.values.map((location) => location["name"].toString()).toList();
        });
      }
    });
  }

  void _saveUser() {
    final newUser = {
      "firstName": firstNameController.text,
      "lastName": lastNameController.text,
      "username": usernameController.text,
      "email": emailController.text,
      "phone": phoneController.text,
      "department": selectedDepartment ?? "",
      "role": selectedRole ?? "",
      "location": selectedLocation ?? "",
      "status": selectedStatus,
    };

    if (widget.user == null) {
      print(selectedRole);
      _database.push().set(newUser);
      _signUp(emailController.text, "test@123", selectedRole!);
    } else {
      String userId = widget.user!["id"]!;
      _database.child(userId).update(newUser);
    }

    widget.onUserUpdated();
    Navigator.pop(context);
  }

  void _signUp(String email, String password, String role) async {
    if (email.isNotEmpty) {
      User? user = await _authService.signUpWithEmail(email, password, role);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.user == null ? "Add User" : "Edit User"),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            TextField(controller: firstNameController, decoration: InputDecoration(labelText: "First Name")),
            TextField(controller: lastNameController, decoration: InputDecoration(labelText: "Last Name")),
            TextField(controller: usernameController, decoration: InputDecoration(labelText: "Username")),
            TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: phoneController, decoration: InputDecoration(labelText: "Phone")),
            DropdownButtonFormField(
              value: selectedDepartment,
              items: departments.map((department) => DropdownMenuItem(value: department, child: Text(department))).toList(),
              onChanged: (value) => setState(() => selectedDepartment = value.toString()),
              decoration: InputDecoration(labelText: "Department"),
            ),
            DropdownButtonFormField(
              value: selectedRole,
              items: roles.map((role) => DropdownMenuItem(value: role, child: Text(role))).toList(),
              onChanged: (value) => setState(() => selectedRole = value.toString()),
              decoration: InputDecoration(labelText: "Role"),
            ),
            DropdownButtonFormField(
              value: selectedLocation,
              items: locations.map((location) => DropdownMenuItem(value: location, child: Text(location))).toList(),
              onChanged: (value) => setState(() => selectedLocation = value.toString()),
              decoration: InputDecoration(labelText: "Location"),
            ),
            Row(
              children: [
                Text("Status: "),
                Radio(value: "Active", groupValue: selectedStatus, onChanged: (value) => setState(() => selectedStatus = value.toString())),
                Text("Active"),
                Radio(value: "Inactive", groupValue: selectedStatus, onChanged: (value) => setState(() => selectedStatus = value.toString())),
                Text("Inactive"),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
        ElevatedButton(style:ElevatedButton.styleFrom(backgroundColor: Colors.green,foregroundColor: Colors.white),onPressed: _saveUser, child: Text(widget.user == null ? "Submit" : "Update")),
      ],
    );
  }
}
