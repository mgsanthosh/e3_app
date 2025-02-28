import 'package:flutter/material.dart';
import '../utils/esgGoalsAndTargets.dart';
import 'EsgGoalDetailScreen.dart';
import 'SubCategoryDetailScreen.dart';

class EsgGoalsAndTargetScreen extends StatefulWidget {
  const EsgGoalsAndTargetScreen({super.key});

  @override
  State<EsgGoalsAndTargetScreen> createState() => _EsgGoalsAndTargetScreenState();
}

class _EsgGoalsAndTargetScreenState extends State<EsgGoalsAndTargetScreen> {
  void _navigateToDetailScreen(BuildContext context, String goalName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EsgGoalDetailScreen(goalName: goalName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> esgGoals = getEsgGoalsCard();
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: esgGoals.length,
          itemBuilder: (context, index) {
            var goal = esgGoals[index];
            return GestureDetector(
              onTap: () => _navigateToDetailScreen(context, goal["name"]),
              child: Card(
                color: goal["cardColor"],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal["name"],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        goal["subtitle"],
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
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
    );
  }
}