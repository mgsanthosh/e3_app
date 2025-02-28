import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../utils/esgGoalsAndTargets.dart';

class MeasurableScreen extends StatefulWidget {
  @override
  _MeasurableScreenState createState() => _MeasurableScreenState();
}

class _MeasurableScreenState extends State<MeasurableScreen> {
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  String? _creatorId;
  Map<String, dynamic> _esgData = {};
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _fetchCreatorId();
  }

  // Fetch creatorId from Firestore
  void _fetchCreatorId() async {
    if (_currentUser == null) return;

    DocumentSnapshot userDoc = await _firestore.collection("users").doc(_currentUser!.uid).get();
    if (userDoc.exists) {
      setState(() {
        _creatorId = userDoc["creator"];
      });
      _fetchEsgData();
    }
  }

  // Fetch ESG Data from Realtime Database
  void _fetchEsgData() {
    if (_creatorId == null) return;

    _database.ref("managers/$_creatorId/esgData").onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          _esgData = data.map((key, value) => MapEntry(key.toString(), value));
          _selectedCategory ??= _esgData.keys.first; // Select first category by default
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Measurable Data")),
      body: _esgData.isEmpty
          ? Center(child: CircularProgressIndicator()) // Show loader if data is empty
          : Column(
        children: [
          // Tabs for categories
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _esgData.keys.map((category) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: ChoiceChip(
                    label: Text(category, style: TextStyle(fontSize: 16)),
                    selected: _selectedCategory == category,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    selectedColor: Colors.blue.shade200,
                  ),
                );
              }).toList(),
            ),
          ),

          // Display ESG Data in Cards
          Expanded(
            child: _selectedCategory == null
                ? Center(child: Text("No data available"))
                : ListView(
              padding: EdgeInsets.all(10),
              children: (_esgData[_selectedCategory] as Map<dynamic, dynamic>).entries.map((entry) {
                final Map<String, dynamic> esgDetails = Map<String, dynamic>.from(entry.value);

                String name = entry.key.toString();
                String startDate = esgDetails["Start Date"]?.toString() ?? "N/A";
                String endDate = esgDetails["Deadline"]?.toString() ?? "N/A";

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        Text("Start: $startDate  |  End: $endDate", style: TextStyle(color: Colors.grey[700])),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () => _showContributionPopup(context),
                              child: Text("Contribute"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // Pop-up for contributing Carbon Emission
  void _showContributionPopup(BuildContext context) {
    List<dynamic> emissionsList = getCarbonEmissionValuesList();
    String? selectedEmissionType;
    double emissionFactor = 0.0;
    String emissionFactorTitle = "";
    String inputTitle = "";
    double inputValue = 0.0;
    double carbonFootprint = 0.0;
    bool isCalculationDone = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Contribute to Carbon Reduction"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: selectedEmissionType,
                    hint: Text("Select Type"),
                    isExpanded: true,
                    items: emissionsList.map((e) {
                      return DropdownMenuItem<String>(
                        value: e["name"],
                        child: Text(e["name"]),
                      );
                    }).toList(),
                    onChanged: (value) {
                      final selectedData = emissionsList.firstWhere((e) => e["name"] == value);
                      setState(() {
                        selectedEmissionType = value;
                        emissionFactor = selectedData["emissionFactor"];
                        emissionFactorTitle = selectedData["emissionFactorTitle"];
                        inputTitle = selectedData["inputTitle"];
                      });
                    },
                  ),
                  if (selectedEmissionType != null) ...[
                    SizedBox(height: 10),
                    Text(emissionFactorTitle, style: TextStyle(fontWeight: FontWeight.bold)),
                    TextField(
                      readOnly: true,
                      decoration: InputDecoration(border: OutlineInputBorder(), hintText: emissionFactor.toString()),
                    ),
                    SizedBox(height: 10),
                    Text(inputTitle, style: TextStyle(fontWeight: FontWeight.bold)),
                    TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          inputValue = double.tryParse(value) ?? 0;
                        });
                      },
                      decoration: InputDecoration(border: OutlineInputBorder(), hintText: "Enter value"),
                    ),
                  ],
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        carbonFootprint = inputValue * emissionFactor;
                        isCalculationDone = true;
                      });
                    },
                    child: Text("Calculate Carbon Footprint"),
                  ),
                  if (isCalculationDone) Text("Carbon Footprint: $carbonFootprint kg CO2e"),
                  if (isCalculationDone)
                    ElevatedButton(
                      onPressed: () {
                        _database.ref("managers/$_creatorId/approvals").push().set({
                          "type": selectedEmissionType,
                          "carbonFootprint": carbonFootprint,
                        });
                        Navigator.pop(context);
                      },
                      child: Text("Save"),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
