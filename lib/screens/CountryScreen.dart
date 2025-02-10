import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../widgets/AddCountryDialog.dart';
import '../widgets/EditCountryDialog.dart';

class CountryScreen extends StatefulWidget {
  @override
  _CountryScreenState createState() => _CountryScreenState();
}

class _CountryScreenState extends State<CountryScreen> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref("countries");

  List<Map<String, String>> countries = [];

  @override
  void initState() {
    super.initState();
    _fetchCountries();
  }

  void _fetchCountries() {
    _database.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          countries = data.entries.map((entry) {
            final country = Map<String, dynamic>.from(entry.value);
            return {
              "id": entry.key.toString(),
              "name": country["name"]?.toString() ?? "",
              "code": country["code"]?.toString() ?? "",
              "description": country["description"]?.toString() ?? "",
              "status": country["status"]?.toString() ?? "Active",
            };
          }).toList().cast<Map<String, String>>();
        });
      }
    });
  }

  void _openAddCountryDialog() {
    showDialog(
      context: context,
      builder: (context) => AddCountryDialog(onCountryAdded: _fetchCountries),
    );
  }

  void _openEditCountryDialog(Map<String, String> country) {
    showDialog(
      context: context,
      builder: (context) => EditCountryDialog(
        country: country,
        onUpdate: _fetchCountries,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Countries")),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: countries.length,
          itemBuilder: (context, index) {
            final country = countries[index];

            return GestureDetector(
              onTap: () => _openEditCountryDialog(country),
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
                            country["name"]!,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text("Code: ${country["code"]}"),
                          SizedBox(height: 4),
                          Text("Description: ${country["description"]}"),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: country["status"] == "Active" ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          country["status"]!,
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
        onPressed: _openAddCountryDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
