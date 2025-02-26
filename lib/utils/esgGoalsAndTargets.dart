import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

List<dynamic> getEsgGoalsCard() {
  return [
    {
      "name": "Environmental",
      "subtitle": "6 Subcategories",
      "cardColor": Colors.green
    },
    {
      "name": "Social",
      "subtitle": "6 Subcategories",
      "cardColor": Colors.blue
    },
    {
      "name": "Governance",
      "subtitle": "5 Subcategories",
      "cardColor": Colors.orange
    }
  ];
}

List<dynamic> getEsgSubCategories(String category) {
  if(category == "Environmental") {
    return [
      {
        "name": "Energy Efficiency"
      },
      {
        "name": "Sustainable Water Management"
      },
      {
        "name": "Biodiversity and Conservation"
      },
      {
        "name": "Carbon Emissions"
      },
      {
        "name": "Environmental Policy and Report"
      },
      {
        "name": "Waste Management"
      }
    ];
  } else if (category == "Social") {
    return [];
  } else  {
    return [];
  }
}


List<dynamic> getAddGoalForm() {
  return [
    {
      "section": "Basic",
      "inputs": [
        {
          "type": "radio",
          "options": ["Measurable", "NonMeasurable"]
        },
        {
          "type": "text",
          "Placeholder": "Description"
        },
        {
          "type": "dropdown",
          "Placeholder": "Department",
          "fromFirebase": true,
          "databaseName": "departments"
        }
      ]
    },
    {
      "section": "Frequency",
      "inputs": [
        {
          "type": "date",
          "Placeholder": "Start Date"
        },
        {
          "type": "date",
          "Placeholder": "Deadline"
        },
        {
          "type": "dropdown",
          "Placeholder": "Select Tracking Frequency",
          "fromFirebase": false,
          "options": ["Daily", "Weekly", "Monthly", "Quarterly", "Annually"]
        }
      ]
    },
    {
      "section": "Scope",
      "inputs": [
        {
          "type": "dropdown",
          "Placeholder": "Select Scope",
          "fromFirebase": false,
          "options": ["Country"]
        },
        {
          "type": "dropdown",
          "Placeholder": "Select Country",
          "fromFirebase": true,
          "databaseName": "countries"
        },
      ]
    },
    {
      "section": "Target",
      "inputs": [
        {
          "type": "text",
          "Placeholder": "Baseline Value"
        },
        {
          "type": "text",
          "Placeholder": "Initial Value"
        },
      ]
    }
  ];
}