import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddCountryDialog extends StatefulWidget {
  final Function() onCountryAdded;

  AddCountryDialog({required this.onCountryAdded});

  @override
  _AddCountryDialogState createState() => _AddCountryDialogState();
}

class _AddCountryDialogState extends State<AddCountryDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final DatabaseReference _database = FirebaseDatabase.instance.ref("countries");

  void _addCountry() {
    if (_formKey.currentState!.validate()) {
      final newCountry = {
        "name": _nameController.text.trim(),
        "code": _codeController.text.trim(),
        "description": _descriptionController.text.trim(),
        "status": "Active",
      };

      _database.push().set(newCountry).then((_) {
        widget.onCountryAdded(); // Refresh country list
        Navigator.pop(context); // Close dialog
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Country"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Country Name"),
              validator: (value) => value!.isEmpty ? "Enter country name" : null,
            ),
            TextFormField(
              controller: _codeController,
              decoration: InputDecoration(labelText: "Country Code"),
              validator: (value) => value!.isEmpty ? "Enter country code" : null,
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: "Description"),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), // Close dialog
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: _addCountry,
          child: Text("Submit"),
        ),
      ],
    );
  }
}
