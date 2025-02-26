import 'package:firebase_auth/firebase_auth.dart';
import 'shared_pref_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
  Future<User?> signUpWithEmail(String email, String password, String role) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = userCredential.user;
    if (user != null) {

      // await SharedPrefService.saveUserEmail(user.email!); // Save user data
      await _firestore.collection("users").doc(user.uid).set({
        "email": user.email,
        "role": role.toUpperCase(),
      });
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

  // Fetch User Role
  Future<String?> getUserRole() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection("users").doc(user.uid).get();
      return userDoc.get("role") as String?;
    }
    return null;
  }
}
