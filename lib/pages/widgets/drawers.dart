// import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_voting_app/pages/Main_Pages/faq.dart';
import 'package:online_voting_app/pages/Main_Pages/login_page.dart';

class Drawers extends StatefulWidget {
  const Drawers({super.key});

  @override
  State<Drawers> createState() => _DrawersState();
}

class _DrawersState extends State<Drawers> {
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
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
                  await FirebaseAuth.instance.signOut();

                  // Navigate to LoginPage after signing out
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
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
