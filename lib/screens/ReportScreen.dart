import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ReportScreen extends StatefulWidget {
  ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  String? _creatorId;
  String? _role;
  Map<String, dynamic> _esgData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCreatorId();
  }

  void _fetchCreatorId() async {
    if (_currentUser == null) return;

    DocumentSnapshot userDoc = await _firestore.collection("users").doc(_currentUser!.uid).get();
    if (userDoc.exists && mounted) {
      setState(() {
        _role = userDoc["role"];
        _creatorId = _role == "MANAGER" ? _currentUser!.uid : userDoc["creator"];
      });
      _fetchEsgData();
    }
  }

  void _fetchEsgData() {
    if (_creatorId == null) return;
    _database.ref("managers/$_creatorId/esgData").onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null && mounted) {
        setState(() {
          _esgData = data.map((key, value) => MapEntry(key.toString(), value));
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Report Overview"),
        backgroundColor: Colors.blueAccent,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _esgData.isEmpty
          ? Center(child: Text("No data available", style: TextStyle(fontSize: 18)))
          : Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              for (var category in _esgData.keys)
                Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category,
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        for (var subCategory in _esgData[category]?.keys ?? [])
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Text(
                                subCategory,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600, color: Colors.blue),
                              ),
                              SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: DataTable(
                                  columns: [
                                    DataColumn(label: Text("Description")),
                                    DataColumn(label: Text("Baseline")),
                                    DataColumn(label: Text("Initial")),
                                    DataColumn(label: Text("Status"))
                                  ],
                                  rows: (_esgData[category][subCategory]?.values ?? [])
                                      .map<DataRow>((entry) {
                                    return DataRow(cells: [
                                      DataCell(Text(entry["Description"] ?? "N/A")),
                                      DataCell(Text(entry["Baseline Value"] ?? "N/A")),
                                      DataCell(Text(entry["Initial Value"] ?? "N/A")),
                                      DataCell(Text(entry["status"] ?? "N/A"))
                                    ]);
                                  }).toList(),
                                ),
                              ),
                              SizedBox(height: 15),
                              PieChartWidget(data: _esgData[category][subCategory] ?? {}),
                              SizedBox(height: 20),
                              BarChartWidget(data: _esgData[category][subCategory] ?? {}),
                            ],
                          )
                      ],
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
class PieChartWidget extends StatelessWidget {
  dynamic data;

  PieChartWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Center(child: Text("No chart data available", style: TextStyle(fontSize: 16)));
    }
    data = data as Map<dynamic, dynamic>?;
    data = data.entries.map((e) => Map<String, dynamic>.from(e.value)).toList();
    List<PieChartSectionData> sections = [];
    for(Map<dynamic, dynamic> entry in data) {
      double initial = double.tryParse(entry["Initial Value"]?.toString() ?? "0") ?? 0;
      sections.add(PieChartSectionData(
        value: initial,
        title: entry["Description"] ?? "N/A",
        color: Colors.primaries[sections.length % Colors.primaries.length],
        radius: 50,
      ));
    }
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text("Category Distribution", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 200,
              child: PieChart(
                PieChartData(
                  sections: sections,
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BarChartWidget extends StatelessWidget {
  final dynamic data;

  BarChartWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Center(
        child: Text("No chart data available", style: TextStyle(fontSize: 16)),
      );
    }

    List<BarChartGroupData> barGroups = [];
    int index = 0;

    for (var entry in data.entries) {
      double baseline = double.tryParse(entry.value["Baseline Value"]?.toString() ?? "0") ?? 0;
      double initial = double.tryParse(entry.value["Initial Value"]?.toString() ?? "0") ?? 0;

      barGroups.add(
        BarChartGroupData(
          x: index++,
          barRods: [
            BarChartRodData(toY: baseline, color: Colors.blue, width: 15),
            BarChartRodData(toY: initial, color: Colors.green, width: 15),
          ],
        ),
      );
    }

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              "ESG Data Comparison",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  barGroups: barGroups,
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(value.toInt().toString(), style: TextStyle(fontSize: 12));
                        },
                        reservedSize: 30,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          print(value);
                          print(data);
                          return Text(
                            data[data.keys.elementAt(value.toInt())]['Description'],
                            style: TextStyle(fontSize: 10),
                            overflow: TextOverflow.ellipsis,
                          );
                        },
                        reservedSize: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

