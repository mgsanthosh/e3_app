import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class EditCountryDialog extends StatefulWidget {
  final Map<String, String> country;
  final VoidCallback onUpdate;

  EditCountryDialog({required this.country, required this.onUpdate});

  @override
  _EditCountryDialogState createState() => _EditCountryDialogState();
}

class _EditCountryDialogState extends State<EditCountryDialog> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref("countries");

  late TextEditingController nameController;
  late TextEditingController codeController;
  late TextEditingController descriptionController;
  String selectedStatus = "Active";

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.country["name"]);
    codeController = TextEditingController(text: widget.country["code"]);
    descriptionController = TextEditingController(text: widget.country["description"]);
    selectedStatus = widget.country["status"] ?? "Active";
  }

  void _updateCountry() {
    String countryId = widget.country["id"]!;
    _database.child(countryId).update({
      "name": nameController.text,
      "code": codeController.text,
      "description": descriptionController.text,
      "status": selectedStatus,
    }).then((_) {
      widget.onUpdate();
      Navigator.pop(context);
    }).catchError((error) {
      print("Error updating country: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Edit Country"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: "Name"),
          ),
          TextField(
            controller: codeController,
            decoration: InputDecoration(labelText: "Code"),
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(labelText: "Description"),
          ),
          SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: selectedStatus,
            decoration: InputDecoration(labelText: "Status"),
            items: ["Active", "In Active"].map((status) {
              return DropdownMenuItem(value: status, child: Text(status));
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedStatus = value!;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: _updateCountry,
          child: Text("Save"),
        ),
      ],
    );
  }
}
