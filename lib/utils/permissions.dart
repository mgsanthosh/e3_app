import 'package:flutter/cupertino.dart';

List<dynamic> getUserPermissions(String role) {
  if (role == "ADMIN") {
    return [
      {
        "name":"Dashboard",
      },
      {
        "name": "Master Data",
        "options": [
          {
            "name": "Countries"
          },
          {
            "name": "Regions"
          },
          {
            "name": "Locations"
          },
          {
            "name":"Profile"
          }
        ]
      },
      {
        "name": "User Management",
        "options":[
          {
            "name": "Departments"
          },
          {
            "name":"Users"
          },
          {
            "name":"Roles"
          }
        ]
      }

    ];
  } else if (role == "MANAGER") {
    return [
      {
        "name":"Dashboard"
      },
      {
        "name":"Master Data",
        "options":[
          {
            "name":"Sectors"
          },
          {
            "name":"Locations"
          },
          {
            "name":"Countries"
          },
          {
            "name":"Regions"
          },
          {
            "name":"Standards"
          },
          {
            "name":"ESG Goals and Targets"
          },
          {
            "name":"ESG Categories"
          },
          {
            "name":"My Goal Tracking"
          },
          {
            "name":"SDG Goals"
          }
        ]

      },
      {
        "name":"ESG Audit",
      },
      {
        "name":"User Management"
      }
    ];
  } else {
    return [
      {
        "name":"Dashboard"
      },
      {
        "name":"Master Data",
        "options":[
          {
            "name":"Standards"
          },
          {
            "name":"Goal Tracking"
          }
        ]
      },
      {
        "name":"ESG Audit"
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