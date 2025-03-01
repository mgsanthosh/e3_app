import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ApprovalsScreen extends StatefulWidget {
  final String? creatorId;
  final String? role;
  final Map<String, dynamic> esgDetails;
  final String category;
  ApprovalsScreen({this.creatorId, this.role, required this.esgDetails, required this.category});

  @override
  State<ApprovalsScreen> createState() => _ApprovalsScreenState();
}

class _ApprovalsScreenState extends State<ApprovalsScreen> {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  List<Map<String, dynamic>> _approvals = [];
  List<String> _approvalKeys = [];

  @override
  void initState() {
    print("THE CAT " + widget.category);
    super.initState();
    _fetchApprovals();
  }

  void _fetchApprovals() {
    _database.ref("managers/${widget.creatorId}/approvals").onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          _approvalKeys = data.keys.cast<String>().toList();
          _approvals = data.entries.map((e) => Map<String, dynamic>.from(e.value)).where((approval) => approval["description"] == widget.category).toList();
        });
      }
    });
  }

  void _rejectApproval(int index) {
    String approvalKey = _approvalKeys[index];
    _database.ref("managers/${widget.creatorId}/approvals/$approvalKey").remove().then((_) {
      setState(() {
        _approvals.removeAt(index);
        _approvalKeys.removeAt(index);
      });
    }).catchError((error) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text("Error rejecting approval: $error")),
      // );
    });
  }

  void _approveValue(dynamic esgValues, int index) {
    String category = esgValues["category"];
    String subCategory = esgValues["name"];
    dynamic newValue = esgValues["newValue"];
    String esgKey = esgValues["esgKey"];

    DatabaseReference ref = _database.ref("managers/${widget.creatorId}/esgData/$category/$subCategory/$esgKey");

    ref.update({"Initial Value": newValue}).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Approval successful: Initial value updated.")),
      );
      _rejectApproval(index);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating value: $error")),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Approvals")),
      body: ListView.builder(
        itemCount: _approvals.length,
        itemBuilder: (context, index) {
          final approval = _approvals[index];
          return Card(
            child: ListTile(
              title: Text(approval["name"] ?? "Unknown"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Baseline: ${approval["baselineValue"] ?? "N/A"}"),
                  Text("Initial: ${approval["initialValue"] ?? "N/A"}"),
                  Text(
                    "New: ${approval["newValue"] ?? "N/A"}",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  Text("Status: ${approval["status"] ?? "Pending"}"),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(icon: Icon(Icons.check), onPressed: () => _approveValue(approval, index)),
                  IconButton(icon: Icon(Icons.close), onPressed: () => _rejectApproval(index)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

}
