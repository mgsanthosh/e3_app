import 'package:flutter/material.dart';

import '../utils/esgGoalsAndTargets.dart';
import 'SubCategoryDetailScreen.dart';

class EsgGoalDetailScreen extends StatelessWidget {
  final String goalName;

  const EsgGoalDetailScreen({super.key, required this.goalName});

  void _navigateToSubCategoryScreen(BuildContext context, String subCategoryName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubCategoryDetailScreen(subCategoryName: subCategoryName, categoryName: goalName,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> subCategories = getEsgSubCategories(goalName);
    return Scaffold(
      appBar: AppBar(
        title: Text(goalName),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: subCategories.length,
          itemBuilder: (context, index) {
            var subCategory = subCategories[index];
            return GestureDetector(
              onTap: () => _navigateToSubCategoryScreen(context, subCategory["name"]),
              child: Card(
                color: Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    subCategory["name"],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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