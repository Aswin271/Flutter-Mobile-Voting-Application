import 'package:flutter/material.dart';
import 'package:online_voting_app/pages/Main_Pages/about_page.dart';
import 'package:online_voting_app/pages/Main_Pages/user_election_view.dart';
import 'package:online_voting_app/pages/Main_Pages/user_view_results.dart';
import 'package:online_voting_app/pages/widgets/action_box.dart';
import 'package:online_voting_app/pages/widgets/drawers.dart'; // Import your custom drawer file
import 'faq.dart'; // Import the FAQ screen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Quick',
                  style: TextStyle(
                    color: Colors.lightBlue[300], // Light blue for "Quick"
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                TextSpan(
                  text: 'Vote',
                  style: TextStyle(
                    color: Colors.purple[400], // Purple for "Vote"
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Opens the drawer
            },
          ),
        ),
        actions: [
          IconButton(
            color: Colors.white,
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationVersion: '^1.0.0',
                applicationIcon: CircleAvatar(
                  radius: 30.0,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage('assets/online-voting.png'),
                ),
                applicationName: 'QuickVote',
                applicationLegalese: 'MCA Mini Project',
              );
            },
            icon: Icon(Icons.info_outline),
          ),
        ],
        backgroundColor: Color.fromARGB(255, 69, 41, 195),
        elevation: 2,
      ),
      drawer: Drawers(),
      // Replace with your actual drawer
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: SingleChildScrollView(
          // Add SingleChildScrollView
          child: Center(
            child: Container(
              margin: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        // Use Expanded to handle widget resizing
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserElectionView()),
                            );
                          },
                          child: ActionBox(
                            image: Icons.how_to_vote,
                            action: "Elections",
                            description: "Active Elections",
                          ),
                        ),
                      ),
                      // Expanded(
                      //   child: GestureDetector(
                      //     onTap: () {
                      //       // Define the action for "View Candidates"
                      //     },
                      //     child: ActionBox(
                      //       image: Icons.person,
                      //       action: "View Candidates",
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        // Use Expanded to handle widget resizing
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserViewResults()),
                            );
                          },
                          child: ActionBox(
                            image: Icons.poll,
                            action: "View Results",
                            description: "To View the Poll Results",
                          ),
                        ),
                      ),
                      // Expanded(
                      //   child: GestureDetector(
                      //     onTap: () {
                      //       // Define the action for "View Candidates"
                      //     },
                      //     child: ActionBox(
                      //       image: Icons.person,
                      //       action: "Add Student Details",
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        // Use Expanded for about and FAQ rows
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AboutPage()),
                            );
                          },
                          child: ActionBox(
                            image: Icons.info,
                            action: "About",
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Faq()),
                            );
                          },
                          child: ActionBox(
                            image: Icons.description,
                            action: "FAQ",
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
