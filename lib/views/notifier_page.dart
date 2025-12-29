import 'package:flutter/material.dart';

class NotifierPage extends StatelessWidget {
  const NotifierPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications"), centerTitle: true),

      body: const Center(
        child: Text(
          "Aucune notification reçue",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),

      //    SnackBar(content: Text("Pas de Notification T"))
    );
  }
}
