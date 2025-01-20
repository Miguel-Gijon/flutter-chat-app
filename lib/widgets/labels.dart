import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String route;
  final String firstLabel;
  final String secondLabel;

  const Labels({
    Key? key,
    required this.route, 
    required this.firstLabel, 
    required this.secondLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(firstLabel,
              style: const TextStyle(color: Colors.black54, fontSize: 15)),
          const SizedBox(height: 10),
          GestureDetector(
            child: Text(secondLabel,
                style: TextStyle(color: Colors.blue[600], fontSize: 18)),
            onTap: () {
              Navigator.pushReplacementNamed(context, route);
            },
          ),
        ],
      ),
    );
  }
}
