import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/esgGoalsAndTargets.dart';

class SubCategoryDetailScreen extends StatefulWidget {
  final String subCategoryName;
  final String categoryName;

  const SubCategoryDetailScreen({
    super.key,
    required this.subCategoryName,
    required this.categoryName,
  });

  @override
  State<SubCategoryDetailScreen> createState() => _SubCategoryDetailScreenState();
}

class _SubCategoryDetailScreenState extends State<SubCategoryDetailScreen> {
  late DatabaseReference _databaseReference;
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  Map<String, List<String>> firebaseData = {}; // Stores fetched Firebase data
  Map<String, dynamic> formData = {}; // Stores user inputs
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _databaseReference = FirebaseDatabase.instance.ref();
    _fetchDynamicFirebaseData();
    _fetchSavedData();
  }

  /// Fetch dynamic data from Firebase based on form fields
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
                    .where((entry) => entry.value["name"] != null) // Prevent null errors
                    .map((entry) => entry.value["name"].toString())
                    .toList();
              });
            } else {
              setState(() {
                firebaseData[databaseName] = []; // Handle case where no data exists
              });
            }
          });
        }
      }
    }
  }

  /// Saves form data to Firebase under /esgData/{uid}/{category}/{subcategory}
  void _saveToFirebase() {
    if (_currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User is not logged in!")),
      );
      return;
    }

    String path = "/managers/${_currentUser!.uid}/esgData/${widget.categoryName}/${widget.subCategoryName}";
    formData['status'] = "Created";
    _databaseReference.child(path).set(formData).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data saved successfully!")),
      );
      Navigator.pop(context); // Close dialog after saving
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save data: $error")),
      );
    });
  }

  /// Fetch saved data from Firebase and update formData
  void _fetchSavedData() {
    if (_currentUser == null) {
      setState(() => isLoading = false);
      return;
    }
    String path = "/managers/${_currentUser!.uid}/esgData/${widget.categoryName}/${widget.subCategoryName}";
    _databaseReference.child(path).once().then((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        setState(() {
          formData = Map<String, dynamic>.from(data);
          isLoading = false;
        });
      }
      setState(() {
        isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
    });
  }
  /// Show Add Goal dialog with dynamic form fields
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
                      String placeholder = input["Placeholder"];
                      String? databaseName = input["databaseName"];
                      bool fromFirebase = input["fromFirebase"] ?? false;

                      if (input["type"] == "radio") {
                        return Column(
                          children: input["options"].map<Widget>((option) {
                            return RadioListTile(
                              title: Text(option),
                              value: option,
                              groupValue: formData[placeholder],
                              onChanged: (value) {
                                setState(() {
                                  formData[placeholder] = value;
                                });
                              },
                            );
                          }).toList(),
                        );
                      } else if (input["type"] == "text") {
                        return TextField(
                          decoration: InputDecoration(hintText: placeholder),
                          onChanged: (value) {
                            formData[placeholder] = value;
                          },
                        );
                      } else if (input["type"] == "dropdown") {
                        return DropdownButtonFormField<String>(
                          decoration: InputDecoration(hintText: placeholder),
                          value: formData[placeholder] ?? null, // Ensure null safety
                          items: (fromFirebase
                              ? firebaseData[databaseName] ?? []
                              : input["options"] as List<dynamic>)
                              .where((option) => option != null) // Ensure no null options
                              .map<DropdownMenuItem<String>>((option) {
                            return DropdownMenuItem<String>(
                              value: option as String,
                              child: Text(option.toString()),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              formData[placeholder] = value;
                            }
                          },
                        );
                      } else if (input["type"] == "date") {
                        dateControllers[placeholder] = TextEditingController();

                        return TextField(
                          controller: dateControllers.putIfAbsent(placeholder, () => TextEditingController()),
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
                              String formattedDate = "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                              dateControllers[placeholder]?.text = formattedDate;
                              formData[placeholder] = formattedDate;
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
            TextButton(onPressed: _saveToFirebase, child: const Text("Add")),
          ],
        );
      },
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case "created":
        return Colors.green;
      case "inprogress":
        return Colors.orange;
      case "completed":
        return Colors.red;
      default:
        return Colors.grey; // Default color for unknown status
    }
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
        width: double.infinity, // Make the card fill the width
        margin: const EdgeInsets.all(16),
        child: formData.isNotEmpty
            ? Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align text and chip
              children: [
                Expanded(
                  child: Text(
                    formData["Description"] ?? "No data",
                    style: const TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis, // Prevent overflow
                  ),
                ),
                Chip(
                  label: Text(
                    formData["status"] ?? "No status",
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: _getStatusColor(formData["status"]),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                ),
              ],
            ),
          ),
        )
            : const SizedBox(), // Empty space when no data
      )
    );
  }
}
