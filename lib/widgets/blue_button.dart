import 'package:flutter/material.dart';

class BlueButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const BlueButton({
    super.key, 
    required this.text, 
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        shadowColor: Colors.black,
        shape: const StadiumBorder(),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      onPressed: onPressed,
      child: Container(
          width: double.infinity,
          height: 55,
          child: Center(
              child: Text(text,
                  style: const TextStyle(fontSize: 17, color: Colors.white)))),
    );
  }
}
