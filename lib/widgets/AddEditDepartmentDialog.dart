import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddEditDepartmentDialog extends StatefulWidget {
  final Map<String, String>? department;
  final Function onDepartmentUpdated;

  AddEditDepartmentDialog({this.department, required this.onDepartmentUpdated});

  @override
  _AddEditDepartmentDialogState createState() => _AddEditDepartmentDialogState();
}

class _AddEditDepartmentDialogState extends State<AddEditDepartmentDialog> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _status = "Active";

  @override
  void initState() {
    super.initState();
    if (widget.department != null) {
      _nameController.text = widget.department!["name"]!;
      _descriptionController.text = widget.department!["description"]!;
      _status = widget.department!["status"]!;
    }
  }

  void _submitDepartment() {
    final departmentData = {
      "name": _nameController.text,
      "description": _descriptionController.text,
      "status": _status,
    };

    final database = FirebaseDatabase.instance.ref("departments");

    if (widget.department == null) {
      // Add new department
      database.push().set(departmentData).then((_) {
        widget.onDepartmentUpdated();
        Navigator.of(context).pop();
      });
    } else {
      // Edit existing department
      database.child(widget.department!["id"]!).set(departmentData).then((_) {
        widget.onDepartmentUpdated();
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.department == null ? "Add Department" : "Edit Department"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: "Department Name"),
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: "Description"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Status:"),
              Row(
                children: [
                  Radio(
                    value: "Active",
                    groupValue: _status,
                    onChanged: (value) {
                      setState(() {
                        _status = value.toString();
                      });
                    },
                  ),
                  Text("Active"),
                  Radio(
                    value: "Inactive",
                    groupValue: _status,
                    onChanged: (value) {
                      setState(() {
                        _status = value.toString();
                      });
                    },
                  ),
                  Text("Inactive"),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          onPressed: _submitDepartment,
          child: Text(widget.department == null ? "Add" : "Update"),
        ),
      ],
    );
  }
}
