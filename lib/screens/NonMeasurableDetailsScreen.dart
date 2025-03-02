import 'package:flutter/material.dart';

class NonMeasurableDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> esgData;
  final String selectedCategory;
  final String selectedSubCategory;
  final void Function() onFetchEsgData; // Callback function

  const NonMeasurableDetailsScreen({
    super.key,
    required this.esgData,
    required this.selectedCategory,
    required this.selectedSubCategory,
    required this.onFetchEsgData,
  });

  @override
  State<NonMeasurableDetailsScreen> createState() => _NonMeasurableDetailsScreenState();
}

class _NonMeasurableDetailsScreenState extends State<NonMeasurableDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.selectedSubCategory} Details"),
        backgroundColor: Colors.green,
      ),
      body: widget.esgData.isEmpty
          ? const Center(child: Text("No data available", style: TextStyle(fontSize: 16)))
          : ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: widget.esgData.length,
        itemBuilder: (context, index) {
          String key = widget.esgData.keys.elementAt(index);
          Map<String, dynamic> data = widget.esgData[key];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Description",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    data["description"] ?? "No description available",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Disclosure Info",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    data["disclosureInfo"] ?? "No disclosure info available",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
