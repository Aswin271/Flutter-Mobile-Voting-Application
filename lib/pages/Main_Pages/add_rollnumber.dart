// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_voting_app/service/database.dart';
import 'package:random_string/random_string.dart';

class AddRollnumber extends StatefulWidget {
  const AddRollnumber({super.key});

  @override
  State<AddRollnumber> createState() => _AddRollnumberState();
}

class _AddRollnumberState extends State<AddRollnumber> {
  TextEditingController rollController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Roll Number'),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, top: 30.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: TextField(
                controller: rollController,
                decoration: InputDecoration(
                  labelText: 'Enter Roll Number',
                  hintText: 'e.g., MCA23-000', // Show example format here
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.account_circle_rounded),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  String Id = randomAlphaNumeric(10);
                  Map<String, dynamic> rollnoInfoMap = {
                    "Id": Id,
                    "RollNo": rollController.text
                  };
                  await DatabaseMethods()
                      .addRollDetails(rollnoInfoMap, Id)
                      .then((value) {
                    Fluttertoast.showToast(
                      msg: "RollNo Added Successfully",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  });
                },
                child: Text(
                  "ADD",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
