import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddEditRegionDialog extends StatefulWidget {
  final Map<String, String>? region;
  final VoidCallback onRegionUpdated;

  AddEditRegionDialog({this.region, required this.onRegionUpdated});

  @override
  _AddEditRegionDialogState createState() => _AddEditRegionDialogState();
}

class _AddEditRegionDialogState extends State<AddEditRegionDialog> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref("regions");

  final TextEditingController nameController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String selectedStatus = "Active";

  @override
  void initState() {
    super.initState();
    if (widget.region != null) {
      nameController.text = widget.region!["name"]!;
      descriptionController.text = widget.region!["description"]!;
      selectedStatus = widget.region!["status"]!;
    }
  }

  void _saveRegion() {
    final newRegion = {
      "name": nameController.text,
      "description": descriptionController.text,
      "status": selectedStatus,
    };

    if (widget.region == null) {
      // Add new region
      _database.push().set(newRegion);
    } else {
      // Update existing region
      String regionId = widget.region!["id"]!;
      _database.child(regionId).update(newRegion);
    }

    widget.onRegionUpdated();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.region == null ? "Add Region" : "Edit Region"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: "Name"),
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(labelText: "Description"),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Status:"),
              SizedBox(width: 10),
              Row(
                children: [
                  Radio(
                    value: "Active",
                    groupValue: selectedStatus,
                    onChanged: (value) {
                      setState(() {
                        selectedStatus = value.toString();
                      });
                    },
                  ),
                  Text("Active"),
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: "In Active",
                    groupValue: selectedStatus,
                    onChanged: (value) {
                      setState(() {
                        selectedStatus = value.toString();
                      });
                    },
                  ),
                  Text("In Active"),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          onPressed: _saveRegion,
          child: Text(widget.region == null ? "Submit" : "Update"),
        ),
      ],
    );
  }
}
