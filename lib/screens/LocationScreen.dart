import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../widgets/AddEditLocationDialog.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref("locations");

  List<Map<String, String>> locations = [];

  @override
  void initState() {
    super.initState();
    _fetchLocations();
  }

  void _fetchLocations() {
    _database.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          locations = data.entries.map((entry) {
            final location = Map<String, dynamic>.from(entry.value);
            return {
              "id": entry.key.toString(),
              "name": location["name"]?.toString() ?? "",
              "address": location["address"]?.toString() ?? "",
              "region": location["region"]?.toString() ?? "",
              "country": location["country"]?.toString() ?? "",
              "latitude": location["latitude"]?.toString() ?? "",
              "longitude": location["longitude"]?.toString() ?? "",
              "status": location["status"]?.toString() ?? "Active",
            };
          }).toList().cast<Map<String, String>>();
        });
      }
    });
  }

  void _openAddLocationDialog() {
    showDialog(
      context: context,
      builder: (context) => AddEditLocationDialog(onLocationUpdated: _fetchLocations),
    );
  }

  void _openEditLocationDialog(Map<String, String> location) {
    showDialog(
      context: context,
      builder: (context) => AddEditLocationDialog(
        location: location,
        onLocationUpdated: _fetchLocations,
      ),
    );
  }

  void _deleteLocation(String locationId) {
    _database.child(locationId).remove().then((_) {
      setState(() {
        locations.removeWhere((location) => location["id"] == locationId);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Locations")),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: locations.length,
          itemBuilder: (context, index) {
            final location = locations[index];

            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(location["name"]!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Address: ${location["address"]}"),
                    Text("Region: ${location["region"]}"),
                    Text("Country: ${location["country"]}"),
                    Text("Coordinates: ${location["latitude"]}, ${location["longitude"]}"),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _openEditLocationDialog(location),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteLocation(location["id"]!),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddLocationDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
