import 'package:firebase_auth/firebase_auth.dart';
import 'shared_pref_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in with Email & Password
  Future<User?> signInWithEmail(String email, String password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = userCredential.user;
    if (user != null) {
      await SharedPrefService.saveUserEmail(user.email!); // Save user data
    }
    return user;
  }

  // Register with Email & Password
  Future<User?> signUpWithEmail(String email, String password) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = userCredential.user;
    if (user != null) {
      await SharedPrefService.saveUserEmail(user.email!); // Save user data
    }
    return user;
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
    await SharedPrefService.removeUser(); // Clear stored data
  }

  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }
}
