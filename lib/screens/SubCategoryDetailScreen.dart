import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../utils/esgGoalsAndTargets.dart';

class SubCategoryDetailScreen extends StatefulWidget {
  final String subCategoryName;

  const SubCategoryDetailScreen({super.key, required this.subCategoryName});

  @override
  State<SubCategoryDetailScreen> createState() => _SubCategoryDetailScreenState();
}

class _SubCategoryDetailScreenState extends State<SubCategoryDetailScreen> {
  late DatabaseReference _databaseReference;
  Map<String, List<String>> firebaseData = {}; // Stores fetched Firebase data

  @override
  void initState() {
    super.initState();
    _databaseReference = FirebaseDatabase.instance.ref();
    _fetchDynamicFirebaseData();
  }

  void _fetchDynamicFirebaseData() {
    List<dynamic> formFields = getAddGoalForm();

    for (var section in formFields) {
      for (var input in section["inputs"]) {
        if (input["fromFirebase"] == true) {
          String databaseName = input["databaseName"];

          _databaseReference.child(databaseName).onValue.listen((event) {
            final data = event.snapshot.value as Map<dynamic, dynamic>?;
            if (data != null) {
              setState(() {
                firebaseData[databaseName] = data.entries
                    .map((entry) => entry.value["name"].toString())
                    .toList();
              });
            }
          });
        }
      }
    }
  }

  void _showAddDialog(BuildContext context) {
    Map<String, TextEditingController> dateControllers = {};

    showDialog(
      context: context,
      builder: (BuildContext context) {
        List<dynamic> formFields = getAddGoalForm();
        return AlertDialog(
          title: const Text("Add New Goal"),
          content: SingleChildScrollView(
            child: Column(
              children: formFields.map((section) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      section["section"],
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ...section["inputs"].map<Widget>((input) {
                      if (input["type"] == "radio") {
                        return Column(
                          children: input["options"].map<Widget>((option) {
                            return RadioListTile(
                              title: Text(option),
                              value: option,
                              groupValue: null,
                              onChanged: (value) {},
                            );
                          }).toList(),
                        );
                      } else if (input["type"] == "text") {
                        return TextField(
                          decoration: InputDecoration(hintText: input["Placeholder"]),
                        );
                      } else if (input["type"] == "dropdown") {
                        String databaseName = input["databaseName"] ?? "";
                        bool fromFirebase = input["fromFirebase"] ?? false;

                        return DropdownButtonFormField<String>(
                          decoration: InputDecoration(hintText: input["Placeholder"]),
                          items: (fromFirebase
                              ? firebaseData[databaseName] ?? []
                              : input["options"] as List<dynamic>)
                              .map<DropdownMenuItem<String>>((option) {
                            return DropdownMenuItem<String>(
                              value: option as String,
                              child: Text(option.toString()),
                            );
                          }).toList(),
                          onChanged: (value) {},
                        );
                      } else if (input["type"] == "date") {
                        String placeholder = input["Placeholder"];
                        dateControllers[placeholder] = TextEditingController();

                        return TextField(
                          controller: dateControllers[placeholder],
                          decoration: InputDecoration(
                            hintText: placeholder,
                            suffixIcon: const Icon(Icons.calendar_today),
                          ),
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );

                            if (pickedDate != null) {
                              String formattedDate =
                                  "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                              dateControllers[placeholder]?.text = formattedDate;
                            }
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    }).toList(),
                    const SizedBox(height: 10),
                  ],
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Add")),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subCategoryName),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddDialog(context),
          ),
        ],
      ),
      body: Center(
        child: Text(
          "Details for ${widget.subCategoryName}",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
