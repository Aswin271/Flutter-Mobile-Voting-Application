import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseMethods {
  Future addRollDetails(Map<String, dynamic> rollnoInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Rollno")
        .doc(id)
        .set(rollnoInfoMap);
  }

  //Class for adding details of students by the admin
  Future addStudentDetails(
      Map<String, dynamic> studentInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Students")
        .doc(id)
        .set(studentInfoMap);
  }

  //class for retrieving the data of registered students by the admin
  Future<List<Map<String, dynamic>>> getStudentDetails() async {
    List<Map<String, dynamic>> studentList = [];
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("Students").get();
    for (var doc in snapshot.docs) {
      studentList.add(doc.data() as Map<String, dynamic>);
    }
    return studentList;
  }

  //Class for adding candidate details by the admin
  Future<void> addCandidateDetails(
      Map<String, dynamic> candidateInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Candidates")
        .doc(id)
        .set(candidateInfoMap);
  }

  //class for viewing candidate details added by the admin
  Future<List<Map<String, dynamic>>> getCandidateDetails() async {
    List<Map<String, dynamic>> candidateList = [];
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("Candidates").get();
    for (var doc in snapshot.docs) {
      candidateList.add(doc.data() as Map<String, dynamic>);
    }
    return candidateList;
  }

  //class for registering users
  Future<bool> registerUser(
      Map<String, dynamic> userInfoMap, String rollNo, String name) async {
    // Check if the student exists with the given roll number and full name
    QuerySnapshot studentSnapshot = await FirebaseFirestore.instance
        .collection("Students")
        .where('rollNumber',
            isEqualTo: rollNo) // Use 'rollNumber' instead of 'rollNo'
        .where('name', isEqualTo: name) // Match with full name
        .limit(1)
        .get();

    if (studentSnapshot.docs.isNotEmpty) {
      // If student exists, proceed with registration
      String userId = studentSnapshot.docs.first.id; // Get the student ID

      // Add the user info to the Users collection, including the role
      userInfoMap['role'] = 'User'; // Automatically assign the role as User
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userId) // Use the student ID as the user ID
          .set(
              userInfoMap,
              SetOptions(
                  merge: true)); // Merge to avoid overwriting existing data

      return true; // Registration successful
    } else {
      return false; // Registration failed: name and rollNumber do not match
    }
  }
}
