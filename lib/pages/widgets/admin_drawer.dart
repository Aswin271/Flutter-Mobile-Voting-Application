// import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_voting_app/pages/Main_Pages/faq.dart';
import 'package:online_voting_app/pages/Main_Pages/login_page.dart';
import 'package:online_voting_app/pages/Main_Pages/user_view_results.dart';

class AdminDrawer extends StatefulWidget {
  const AdminDrawer({super.key});

  @override
  State<AdminDrawer> createState() => _AdminDrawerState();
}

class _AdminDrawerState extends State<AdminDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(),
      child: Drawer(
        child: Container(
          color: Color.fromARGB(255, 39, 131, 159),
          child: ListView(
            padding: EdgeInsets.all(0.0),
            children: <Widget>[
              //UserAccountsDrawerHeader(
              //accountName: accountName,
              //accountEmail: accountEmail),

              ListTile(
                title: Text("Results"),
                subtitle: Text("View the result of the poll"),
                leading: Icon(Icons.poll),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserViewResults()));
                },
              ),
              ListTile(
                title: Text("Info"),
                subtitle: Text("View the information of the poll"),
                leading: Icon(Icons.info),
                onTap: () {
                  showAboutDialog(
                      context: context,
                      applicationVersion: '^1.0.0',
                      applicationIcon: CircleAvatar(
                        radius: 30.0,
                        backgroundColor: Colors.transparent,
                        backgroundImage: AssetImage('assets/online-voting.png'),
                      ),
                      applicationName: 'QuickVote',
                      applicationLegalese: 'MCA Mini Project');
                },
              ),
              ListTile(
                title: Text("FAQ"),
                subtitle: Text("Frequently Asked Questions"),
                leading: Icon(Icons.settings),
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Faq()));
                },
              ),
              ListTile(
                title: Text("Log Out"),
                subtitle: Text("Log Out"),
                leading: Icon(Icons.logout),
                onTap: () async {
                  // Call the sign-out function
                  await FirebaseAuth.instance.signOut();

                  // After sign-out, reset the navigator stack by using `pushAndRemoveUntil`
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (Route<dynamic> route) =>
                        false, // Remove all routes from the stack
                  );
                },
              ),

              Spacer(),
              Image(
                height: 70,
                image: AssetImage("assets/online-voting.png"),
                filterQuality: FilterQuality.high,
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  "Developed by Aswin J",
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
