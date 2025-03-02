import 'package:flutter/material.dart';

import '../utils/esgGoalsAndTargets.dart';

class NonMeasurableStaticScreen extends StatelessWidget {
  const NonMeasurableStaticScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    List<dynamic> data = getNonMeasurable();

    return Scaffold(
      appBar: AppBar(
        title: Text("Non-Measurable Data"),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Name at the center
                Text(
                  data[index]["name"],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),

                // Card containing content
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      data[index]["content"],
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
