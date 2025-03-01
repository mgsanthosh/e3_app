import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class EsgPopup extends StatefulWidget {
  final String? creatorId;

  EsgPopup({required this.creatorId});

  @override
  _EsgPopupState createState() => _EsgPopupState();
}

class _EsgPopupState extends State<EsgPopup> {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  Map<String, dynamic> _esgData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEsgData();
  }

  void _fetchEsgData() {
    if (widget.creatorId == null) return;

    _database.ref("managers/${widget.creatorId}/esgData").once().then((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      setState(() {
        _esgData = data != null ? data.map((key, value) => MapEntry(key.toString(), value)) : {};
        _isLoading = false;
      });
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
            : Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("ESG Data", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            ..._esgData.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.key, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text("Details: ${entry.value}"),
                  Divider(),
                ],
              );
            }).toList(),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            ),
          ],
        ),
      ),
    );
  }
}
