import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartWidget extends StatelessWidget {
  final Map<String, int> pieValue;
  final String heading;

  PieChartWidget({required this.pieValue, required this.heading});

  @override
  Widget build(BuildContext context) {
    bool isEmpty = pieValue.values.every((count) => count == 0); // Check if all values are zero

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isEmpty)
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "Nothing is created",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          )
        else
          Container(
            child: Column(
              children: [
                Text(this.heading.toString()),
                SizedBox(
                  height: 300,
                  child: PieChart(
                    PieChartData(
                      sections: _generateSections(),
                      sectionsSpace: 2,
                      centerSpaceRadius: 50,
                    ),
                  ),
                ),
              ],
            ),
          ),
        SizedBox(height: 20),
        if (!isEmpty) _buildLegend(),
      ],
    );
  }

  /// Generate Pie Chart Sections from Data
  List<PieChartSectionData> _generateSections() {
    final List<Color> colors = [Colors.blue, Colors.orange, Colors.green];
    final List<String> labels = ["Created", "In Progress", "Completed"];

    return pieValue.entries.map((entry) {
      int index = labels.indexOf(entry.key);
      return PieChartSectionData(
        color: colors[index],
        value: entry.value.toDouble(),
        title: "${entry.value}",
        radius: 50,
        titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();
  }

  /// Build Legend Below Pie Chart
  Widget _buildLegend() {
    final List<Color> colors = [Colors.blue, Colors.orange, Colors.green];
    final List<String> labels = ["Created", "In Progress", "Completed"];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(labels.length, (index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Container(width: 12, height: 12, color: colors[index]),
              SizedBox(width: 5),
              Text(labels[index], style: TextStyle(fontSize: 14)),
            ],
          ),
        );
      }),
    );
  }
}
