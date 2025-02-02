import 'package:e3_app/services/auth_service.dart';
import 'package:e3_app/widgets/SideNav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    final user  = _authService.getCurrentUser();
    final userRole = await _authService.getUserRole();
    setState(()  {
      _currentUser = user;
      role = userRole;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: SideNav(role: role!, user: _currentUser!,),
      body: Container(
        child: Column(
            children: [
              Text(_currentUser!.email.toString()),
              Text(_currentUser!.uid),
              Text(role.toString())
            ],
        ),
      ),
    );
  }
}
