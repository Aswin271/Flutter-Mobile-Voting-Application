import 'package:flutter/material.dart';

class ActionBox extends StatelessWidget {
  final IconData image;
  final String action;
  final String? description;

  const ActionBox({
    Key? key, // Key is now nullable
    required this.image, // Use 'required' instead of '@required'
    required this.action,
    this.description, // Optional description can be nullable
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      height: 180.0,
      width: 150.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.0),
        gradient: LinearGradient(
          end: Alignment.bottomRight,
          tileMode: TileMode.clamp,
          colors: [Colors.indigo, Colors.blue],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            image,
            size: 72.0,
            color: Colors.white,
          ),
          Text(
            action,
            style: TextStyle(
              fontSize: 23.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              icon: Icon(
                Icons.arrow_right_alt,
                color: Colors.white,
              ),
              onPressed: () {
                // Add your onPressed functionality here
              },
            ),
          ),
        ],
      ),
    );
  }
}
