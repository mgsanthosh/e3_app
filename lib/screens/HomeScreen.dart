import 'package:e3_app/screens/Dashboard.dart';
import 'package:e3_app/screens/DepartmentScreen.dart';
import 'package:e3_app/screens/EsgGoalsAndTargetsScreen.dart';
import 'package:e3_app/screens/LocationScreen.dart';
import 'package:e3_app/screens/NonMeasurableScreen.dart';
import 'package:e3_app/screens/RegionScreen.dart';
import 'package:e3_app/screens/UserScreen.dart';
import 'package:e3_app/services/auth_service.dart';
import 'package:e3_app/widgets/SideNav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'CountryScreen.dart';
import 'MeasurableScreen.dart';
import 'RoleScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedScreen = "Dashboard";
  final AuthService _authService = AuthService();
  User? _currentUser;
  String? role;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    _getCurrentUser();
  }

  void _getCurrentUser() async {
    final user = _authService.getCurrentUser();
    final userRole = await _authService.getUserRole();
    setState(() {
      _currentUser = user;
      role = userRole;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(selectedScreen.toUpperCase()),backgroundColor:Colors.green,titleTextStyle: TextStyle(fontSize: 20,color: Colors.white),),
      drawer: SideNav(
        role: role!,
        user: _currentUser!,
        onMenuSelected: (menu) {
          print("THE MENU " + menu);
          setState(() {
            selectedScreen = menu; // Update view dynamically
          });
        },
      ),
      body: Container(
        color: Colors.green[100],
        child: getScreen(selectedScreen),
      )
    );
  }

  Widget getScreen(String screenName) {
    switch (screenName) {
      case "Dashboard":
        return DashboardScreen();
      case "Master Data":
        return Center(
            child: Text("Master Data View", style: TextStyle(fontSize: 20)));
      case "User Management":
        return Center(
            child:
                Text("User Management View", style: TextStyle(fontSize: 20)));
      case "Locations":
        return LocationScreen();
      case "Departments":
        return DepartmentScreen();
      case "Countries":
        return CountryScreen();
      case "Regions":
        return RegionScreen();
      case "Roles":
        return RoleScreen();
      case "Users":
        return UserScreen(mode: "manager");
      case "ESG Audit":
        return Center(
            child: Text("ESG Audit View", style: TextStyle(fontSize: 20)));
      case "ESG Goals and Targets":
        return EsgGoalsAndTargetScreen();
      case "Contributors":
        return UserScreen(mode: "contributor");
      case "Measurable":
        return MeasurableScreen();
      case "Non Measurable":
        return NonMeasurableScreen();
      default:
        return Center(child: Text("Home View", style: TextStyle(fontSize: 20)));
    }
  }
}
