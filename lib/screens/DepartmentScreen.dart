import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../widgets/AddEditDepartmentDialog.dart'; // You'll create this dialog widget

class DepartmentScreen extends StatefulWidget {
  @override
  _DepartmentScreenState createState() => _DepartmentScreenState();
}

class _DepartmentScreenState extends State<DepartmentScreen> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref("departments");

  List<Map<String, String>> departments = [];

  @override
  void initState() {
    super.initState();
    _fetchDepartments();
  }

  void _fetchDepartments() {
    _database.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          departments = data.entries.map((entry) {
            final department = Map<String, dynamic>.from(entry.value);
            return {
              "id": entry.key.toString(),
              "name": department["name"]?.toString() ?? "",
              "description": department["description"]?.toString() ?? "",
              "status": department["status"]?.toString() ?? "Active",
            };
          }).toList().cast<Map<String, String>>();
        });
      }
    });
  }

  void _openAddDepartmentDialog() {
    showDialog(
      context: context,
      builder: (context) => AddEditDepartmentDialog(onDepartmentUpdated: _fetchDepartments),
    );
  }

  void _openEditDepartmentDialog(Map<String, String> department) {
    showDialog(
      context: context,
      builder: (context) => AddEditDepartmentDialog(
        department: department,
        onDepartmentUpdated: _fetchDepartments,
      ),
    );
  }

  void _deleteDepartment(String departmentId) {
    _database.child(departmentId).remove().then((_) {
      setState(() {
        departments.removeWhere((department) => department["id"] == departmentId);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F6EB),
      //appBar: AppBar(title: Text("Departments")),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: departments.length,
          itemBuilder: (context, index) {
            final department = departments[index];

            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(department["name"]!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Description: ${department["description"]}"),
                    Text("Status: ${department["status"]}"),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _openEditDepartmentDialog(department),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteDepartment(department["id"]!),
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
        onPressed: _openAddDepartmentDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
