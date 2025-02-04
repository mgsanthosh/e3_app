import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddEditRoleDialog extends StatefulWidget {
  final Map<String, String>? role;
  final Function onRoleUpdated;

  AddEditRoleDialog({this.role, required this.onRoleUpdated});

  @override
  _AddEditRoleDialogState createState() => _AddEditRoleDialogState();
}

class _AddEditRoleDialogState extends State<AddEditRoleDialog> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _status = "Active";

  @override
  void initState() {
    super.initState();
    if (widget.role != null) {
      _nameController.text = widget.role!["name"]!;
      _descriptionController.text = widget.role!["description"]!;
      _status = widget.role!["status"]!;
    }
  }

  void _submitRole() {
    final roleData = {
      "name": _nameController.text,
      "description": _descriptionController.text,
      "status": _status,
    };

    final database = FirebaseDatabase.instance.ref("roles");

    if (widget.role == null) {
      // Add new role
      database.push().set(roleData).then((_) {
        widget.onRoleUpdated();
        Navigator.of(context).pop();
      });
    } else {
      // Edit existing role
      database.child(widget.role!["id"]!).set(roleData).then((_) {
        widget.onRoleUpdated();
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.role == null ? "Add Role" : "Edit Role"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: "Role Name"),
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
          onPressed: _submitRole,
          child: Text(widget.role == null ? "Add" : "Update"),
        ),
      ],
    );
  }
}
