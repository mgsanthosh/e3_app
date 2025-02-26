import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddEditLocationDialog extends StatefulWidget {
  final Map<String, String>? location;
  final VoidCallback onLocationUpdated;

  AddEditLocationDialog({this.location, required this.onLocationUpdated});

  @override
  _AddEditLocationDialogState createState() => _AddEditLocationDialogState();
}

class _AddEditLocationDialogState extends State<AddEditLocationDialog> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref("locations");
  final DatabaseReference _regionDatabase = FirebaseDatabase.instance.ref("regions");
  final DatabaseReference _countryDatabase = FirebaseDatabase.instance.ref("countries");

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();

  String? selectedRegion;
  String? selectedCountry;
  String selectedStatus = "Active";

  List<String> regions = [];
  List<String> countries = [];

  @override
  void initState() {
    super.initState();
    _fetchRegions();
    _fetchCountries();

    if (widget.location != null) {
      nameController.text = widget.location!["name"]!;
      addressController.text = widget.location!["address"]!;
      latitudeController.text = widget.location!["latitude"]!;
      longitudeController.text = widget.location!["longitude"]!;
      selectedRegion = widget.location!["region"];
      selectedCountry = widget.location!["country"];
      selectedStatus = widget.location!["status"]!;
    }
  }

  void _fetchRegions() async {
    _regionDatabase.once().then((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          regions = data.values.map((region) => region["name"].toString()).toList();
        });
      }
    });
  }

  void _fetchCountries() async {
    _countryDatabase.once().then((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          countries = data.values.map((country) => country["name"].toString()).toList();
        });
      }
    });
  }

  void _saveLocation() {
    final newLocation = {
      "name": nameController.text,
      "address": addressController.text,
      "region": selectedRegion ?? "",
      "country": selectedCountry ?? "",
      "latitude": latitudeController.text,
      "longitude": longitudeController.text,
      "status": selectedStatus,
    };

    if (widget.location == null) {
      _database.push().set(newLocation);
    } else {
      String locationId = widget.location!["id"]!;
      _database.child(locationId).update(newLocation);
    }

    widget.onLocationUpdated();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.location == null ? "Add Location" : "Edit Location"),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: "Name")),
            TextField(controller: addressController, decoration: InputDecoration(labelText: "Address")),
            DropdownButtonFormField(
              value: selectedRegion,
              items: regions.map((region) => DropdownMenuItem(value: region, child: Text(region))).toList(),
              onChanged: (value) => setState(() => selectedRegion = value.toString()),
              decoration: InputDecoration(labelText: "Region"),
            ),
            DropdownButtonFormField(
              value: selectedCountry,
              items: countries.map((country) => DropdownMenuItem(value: country, child: Text(country))).toList(),
              onChanged: (value) => setState(() => selectedCountry = value.toString()),
              decoration: InputDecoration(labelText: "Country"),
            ),
            TextField(controller: latitudeController, decoration: InputDecoration(labelText: "Latitude")),
            TextField(controller: longitudeController, decoration: InputDecoration(labelText: "Longitude")),
            Row(
              children: [
                Text("Status: "),
                Radio(value: "Active", groupValue: selectedStatus, onChanged: (value) => setState(() => selectedStatus = value.toString())),
                Text("Active"),
                Radio(value: "In Active", groupValue: selectedStatus, onChanged: (value) => setState(() => selectedStatus = value.toString())),
                Text("In Active"),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
        ElevatedButton(style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,),
            onPressed: _saveLocation, child: Text(widget.location == null ? "Submit" : "Update")),
      ],
    );
  }
}
