import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../widgets/AddRegionDialog.dart';

class RegionScreen extends StatefulWidget {
  @override
  _RegionScreenState createState() => _RegionScreenState();
}

class _RegionScreenState extends State<RegionScreen> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref("regions");

  List<Map<String, String>> regions = [];

  @override
  void initState() {
    super.initState();
    _fetchRegions();
  }

  void _fetchRegions() {
    _database.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          regions = data.entries.map((entry) {
            final region = Map<String, dynamic>.from(entry.value);
            return {
              "id": entry.key.toString(),
              "name": region["name"]?.toString() ?? "",
              "code": region["code"]?.toString() ?? "",
              "description": region["description"]?.toString() ?? "",
              "status": region["status"]?.toString() ?? "Active",
            };
          }).toList().cast<Map<String, String>>();
        });
      }
    });
  }

  void _openAddRegionDialog() {
    showDialog(
      context: context,
      builder: (context) => AddEditRegionDialog(onRegionUpdated: _fetchRegions),
    );
  }

  void _openEditRegionDialog(Map<String, String> region) {
    showDialog(
      context: context,
      builder: (context) => AddEditRegionDialog(
        region: region, // Pass the region data for editing
        onRegionUpdated: _fetchRegions,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F6EB),
      //appBar: AppBar(title: Text("Regions")),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: regions.length,
          itemBuilder: (context, index) {
            final region = regions[index];

            return GestureDetector(
              onTap: () => _openEditRegionDialog(region),
              child: Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            region["name"]!,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text("Code: ${region["code"]}"),
                          SizedBox(height: 4),
                          Text("Description: ${region["description"]}"),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: region["status"] == "Active" ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          region["status"]!,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: _openAddRegionDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
