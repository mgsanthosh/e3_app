import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../utils/esgGoalsAndTargets.dart';
import 'PieChartWidget.dart';

class EsgPopup extends StatefulWidget {
  final String? creatorId;
  final item;
  EsgPopup({required this.creatorId, this.item});

  @override
  _EsgPopupState createState() => _EsgPopupState();
}

class _EsgPopupState extends State<EsgPopup> {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  Map<String, dynamic> _esgData = {};
  bool _isLoading = true;
  Map<String, int> pieValue = {};

  @override
  void initState() {
    super.initState();
    _fetchEsgData();
  }

  List<dynamic> getItemsByCategory(String category) {
    return getDashboardCategories()
        .where((item) => item["category"] == category)
        .toList();
  }
  
  void _fetchEsgData() {
    if (widget.creatorId == null) return;

    print(widget.item);
    List<dynamic> itemsBasedOnCategory = getItemsByCategory(widget.item["name"]);
    print(itemsBasedOnCategory);
    _database.ref("managers/${widget.creatorId}/esgData").once().then((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      setState(() {
        _esgData = data != null ? data.map((key, value) => MapEntry(key.toString(), value)) : {};
        _isLoading = false;
      });
      getDashboardDetails(_esgData, itemsBasedOnCategory);
    });
  }

  String getStatus(Map<String, dynamic> esgDetails) {
    double initialValue = double.tryParse(esgDetails["Initial Value"]?.toString() ?? "0") ?? 0;
    double baselineValue = double.tryParse(esgDetails["Baseline Value"]?.toString() ?? "0") ?? 0;

    if (initialValue == 0) return "Created";
    if (initialValue > 0 && initialValue < baselineValue) return "InProgress";
    return "Completed";
  }

  void getDashboardDetails(Map<String, dynamic> esgData, List<dynamic> itemsBasedOnCategory) {
    List<Map<String, dynamic>> dashboardDetailsList = [];

    for (var item in itemsBasedOnCategory) {
      var firstNode = esgData[item["main"]];

      if (firstNode == null) continue; // Skip if the category doesn't exist

      var secondNodeRaw = firstNode[item["name"]];

      // Check if `secondNodeRaw` is a Map before accessing .entries
      List<Map<String, dynamic>> secondNode = [];
      if (secondNodeRaw is Map) {
        secondNode = secondNodeRaw.entries.map((e) => Map<String, dynamic>.from(e.value)).toList();
      }

      if (secondNode.isEmpty) {
        var dashboardDetails = {
          "category": item["category"],
          "secondNode": item["name"],
          "firstNode": item["main"],
          "count": 0,
          "status": null
        };
        dashboardDetailsList.add(dashboardDetails);
      } else {
        for (var secNode in secondNode) {
          var dashboardDetails = {
            "category": item["category"],
            "secondNode": item["name"],
            "firstNode": item["main"],
            "count": secondNode.length.toString(),
            "status": getStatus(secNode)
          };
          dashboardDetailsList.add(dashboardDetails);
        }
      }
    }

    print("Dashboard Details List: $dashboardDetailsList");
    int createCount = 0;
    int inProgressCount = 0;
    int completedCount = 0;
    for(Map<String, dynamic> val in dashboardDetailsList) {
      if(val["status"].toString().toLowerCase() == "created") {
        createCount = createCount + 1;
      }
      if(val["status"].toString().toLowerCase() == "inprogress") {
        inProgressCount = inProgressCount + 1;
      }
      if(val["status"].toString().toLowerCase() == "completed") {
        completedCount = completedCount + 1;
      }
    }
    Map<String, int> pieValueMap = {
      "Created": createCount,
      "In Progress": inProgressCount,
      "Completed": completedCount
    };
    setState(() {
      pieValue = pieValueMap;
      print(pieValue);

    });
  }


  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        padding: EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width * 0.8,
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _esgData.isEmpty
            ? Center(child: Text("No ESG data available"))
            : Center(child: PieChartWidget(pieValue: pieValue, heading: widget.item["heading"],)),
      ),
    );
  }
}
