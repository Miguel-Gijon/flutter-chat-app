import 'package:flutter/material.dart';

enum MessageType { mine, notMine }

class ChatMessage extends StatelessWidget {
  final MessageType type;
  final String texto;
  final String uid;
  final AnimationController animationController;

  const ChatMessage({
    super.key, 
    required this.texto, 
    required this.uid, 
    required this.animationController,
    required this.type
    });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: animationController, 
          curve: Curves.easeOut
          ),
        child: Container(
          child: type == MessageType.mine ? _myMessage() : _notMyMessage(),
        ),
      ),
    );
  }

  Widget _myMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(
          bottom: 5,
          right: 5,
          left: 50,
        ),
        decoration: BoxDecoration(
          color: const Color(0xff4D9EF6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          texto,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _notMyMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(
          bottom: 5,
          right: 50,
          left: 5,
        ),
        decoration: BoxDecoration(
          color: const Color(0xffE4E5E8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          texto,
          style: const TextStyle(color: Colors.black87),
        ),
      ),
    );
  }
}
