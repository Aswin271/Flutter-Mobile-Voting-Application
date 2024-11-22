import 'package:flutter/material.dart';

class Faq extends StatelessWidget {
  const Faq({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQ'),
        backgroundColor:
            Color.fromARGB(255, 69, 41, 195), // Match home screen theme
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          FaqItem(
            question: 'How do I vote online?',
            answer:
                'To vote online, go to the "Go to Vote" section on the home screen and follow the instructions.',
          ),
          FaqItem(
            question: 'Can I change my vote once submitted?',
            answer:
                'No, once you submit your vote, it cannot be changed. Please make sure to review your choices before submitting.',
          ),
          FaqItem(
            question: 'What happens if I forget my login credentials?',
            answer:
                'You can reset your password by clicking on the "Forgot password?" link on the login screen.',
          ),
          // Add more FAQ items as needed
        ],
      ),
    );
  }
}

class FaqItem extends StatelessWidget {
  final String question;
  final String answer;

  const FaqItem({
    Key? key,
    required this.question,
    required this.answer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ExpansionTile(
        title: Text(question, style: TextStyle(fontWeight: FontWeight.bold)),
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(answer),
          ),
        ],
      ),
    );
  }
}
