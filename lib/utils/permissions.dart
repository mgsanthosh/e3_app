import 'package:flutter/cupertino.dart';

List<dynamic> getUserPermissions(String role) {
  if (role == "ADMIN") {
    return [
      {
        "name": "Dashboard",
      },
      {
        "name": "Master Data",
        "options": [
          {"name": "Countries"},
          {"name": "Regions"},
          {"name": "Locations"},
          {"name": "Profile"}
        ]
      },
      {
        "name": "User Management",
        "options": [
          {"name": "Departments"},
          {"name": "Users"},
          {"name": "Roles"}
        ]
      }
    ];
  } else if (role == "MANAGER") {
    return [
      {"name": "Dashboard"},
      {
        "name": "Master Data",
        "options": [
          {"name": "Contributors"}
        ]
      },
      {
        "name": "Goal Management",
        "options": [
          {"name": "ESG Goals and Targets"},
          {
            "name": "My Goal Tracking",
            "options": [
              {"name": "Measurable"},
              {"name": "Non Measurable"}
            ]
          },
        ]
      },
      {
        "name": "Report Generation"
      }
    ];
  } else {
    return [
      {"name": "Dashboard"},
      {
        "name": "Goal Management",
        "options": [
          {
            "name": "Goal Tracking",
            "options": [
              {"name": "Measurable"},
              {"name": "Non Measurable"},
            ]
          },
        ]
      },
      {
        "name": "Report Generation"
      }
    ];
  }
}

void navigateToScreen(BuildContext context, String screenName) {
  Map<String, String> routeMapping = {
    "Dashboard": "/dashboard",
    "Master Data": "/master_data",
    "User Management": "/user_management",
    "Locations": "/master_data",
    "Countries": "/master_data",
    "Regions": "/master_data",
    "Departments": "/user_management",
    "Users": "/user_management",
    "Roles": "/user_management",
    "ESG Audit": "/esg_audit",
  };

  String? route = routeMapping[screenName];
  if (route != null) {
    Navigator.pushNamed(context, route);
  }
}
