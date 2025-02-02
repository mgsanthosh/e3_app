List<dynamic> getUserPermissions(String role) {
  if (role == "ADMIN") {
    return [
      {
        "name":"Dashboard"
      },
      {
        "name": "Master Data",
        "options": [
          {
            "name": "Locations"
          },
          {
            "name": "Countries"
          },
          {
            "name": "Regions"
          },
          {
            "name":"Standards"
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