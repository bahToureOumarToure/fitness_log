import 'package:flutter/material.dart';

import '../views/home_view.dart';
import '../views/profile_page.dart';

class Drawer_page extends StatelessWidget {
  const Drawer_page({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      width: MediaQuery.of(context).size.width * 0.6,
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight),
          Expanded(
            child: Container(
              color: Theme.of(context).canvasColor, // Couleur de fond du menu
              child: ListView(
                children: [
                  ListTile(
                    title: Text("Accueil"),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeView()),
                      );
                    },
                  ),
                  ListTile(title: Text("Profil"),  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
                  },),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
