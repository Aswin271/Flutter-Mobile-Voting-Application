import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> signUpUser(
    Map<String, dynamic> userInfoMap, String email, String password) async {
  try {
    // Create user with email and password
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Get the user ID
    String userId = userCredential.user!.uid;

    // Add additional user info to Firestore
    userInfoMap['role'] = 'User'; // Automatically assign the role as User
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(userId)
        .set(userInfoMap);

    return true; // Registration successful
  } catch (e) {
    print("Error signing up: $e");
    return false; // Registration failed
  }
}

Future<bool> loginUser(String email, String password) async {
  try {
    // Sign in the user
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Get the user ID
    String userId = userCredential.user!.uid;

    // Retrieve user info from Firestore
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection("Users").doc(userId).get();

    if (userDoc.exists) {
      // Access the user details
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      // Now you can access userData['name'], userData['rollNo'], etc.
      return true; // Login successful
    } else {
      return false; // User not found in Firestore
    }
  } catch (e) {
    print("Error logging in: $e");
    return false; // Login failed
  }
}
