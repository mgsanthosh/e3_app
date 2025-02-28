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
        "name": "Energy Efficiency",
        "category": "affordable_and_clean_energy"
      },
      {
        "name": "Sustainable Water Management",
        "category": "clean_water_and_sanitation"
      },
      {
        "name": "Biodiversity and Conservation",
        "category": "climate_action"
      },
      {
        "name": "Carbon Emissions",
        "category": "affordable_and_clean_energy",
      },
      {
        "name": "Environmental Policy and Report",
        "category": "quality_education"
      },
      {
        "name": "Waste Management",
        "category": "clean_water_and_sanitation"
      }
    ];
  } else if (category == "Social") {
    return [
      {
        "name": "Supply Chain Management",
        "category": "quality_education"
      },
      {
        "name": "Human Rights and Labor standards",
        "category": "quality_education"
      },
      {
        "name": "Health and Safety",
        "category": "good_health_and_wellbeing"
      },
      {
        "name": "Human Capital Management",
        "category": "decent_work_and_economic_growth"
      },
      {
        "name": "Community Relations",
        "category": "good_health_and_wellbeing"
      },
      {
        "name": "Customer Privacy",
        "category": "good_health_and_wellbeing"
      }
    ];
  } else  {
    return [
      {
        "name": "Transparency and Reporting",
        "category": "quality_education"
      },
      {
        "name": "Corporate Culture and Ethics",
        "category": "decent_work_and_economic_growth"
      },
      {
        "name": "Audit and Internal Controls",
        "category": "quality_education"
      },
      {
        "name": "Stakeholder Engagement",
        "category": "decent_work_and_economic_growth"
      },
      {
        "name": "Corporate Resilience and Adaptability",
        "category": "decent_work_and_economic_growth"
      }
    ];
  }
}


List<dynamic> getAddGoalForm() {
  return [
    {
      "section": "Basic",
      "inputs": [
        {
          "type": "dropdown",
          "Placeholder": "Select Type",
          "fromFirebase": false,
          "options": ["Measurable", "NonMeasurable"],
          "value": "Measurable"
        },
        {
          "type": "text",
          "Placeholder": "Description",
          "value": "description"
        },
        {
          "type": "dropdown",
          "Placeholder": "Department",
          "fromFirebase": true,
          "databaseName": "departments",
          "value": "departments"
        }
      ]
    },
    {
      "section": "Frequency",
      "inputs": [
        {
          "type": "date",
          "Placeholder": "Start Date",
          "value": "startDate"
        },
        {
          "type": "date",
          "Placeholder": "Deadline",
          "value": "Deadline"
        },
        {
          "type": "dropdown",
          "Placeholder": "Select Tracking Frequency",
          "fromFirebase": false,
          "options": ["Daily", "Weekly", "Monthly", "Quarterly", "Annually"],
          "value": "trackingFreq"
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
          "options": ["Country"],
          "value": "scope"
        },
        {
          "type": "dropdown",
          "Placeholder": "Select Country",
          "fromFirebase": true,
          "databaseName": "countries",
          "value": "countries"
        },
      ]
    },
    {
      "section": "Target",
      "inputs": [
        {
          "type": "text",
          "Placeholder": "Baseline Value",
          "value": "baseline"
        },
        {
          "type": "text",
          "Placeholder": "Initial Value",
          "value": "initial"
        },
      ]
    }
  ];
}


List<dynamic> getCarbonEmissionValuesList() {
  return [
    {
      "name": "Energy Consumption",
      "emissionFactor": 0.5,
      "emisionFactorTitle": "Emission Factor (kg CO2e per kWh)",
      "inputTitle": "Energy Consumption (kWh)"
    },
    {
      "name": "Fuel Consumption",
      "emissionFactor": 8.89,
      "emisionFactorTitle": "Emission Factor (kg CO2e per gallon)",
      "inputTitle": "Fuel Consumption (gallons)"
    },
    {
      "name": "Transportation",
      "emissionFactor": 0.411,
      "emisionFactorTitle": "Emission Factor (kg CO2e per mile)",
      "inputTitle": "Activity Data (miles travelled)"
    },
    {
      "name": "Waste Disposal",
      "emissionFactor": 1.2,
      "emisionFactorTitle": "Emission Factor (kg CO2e per kg)",
      "inputTitle": "Waste Produced (Kg)"
    }
  ];
}