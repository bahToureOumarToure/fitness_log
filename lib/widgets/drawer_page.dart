import 'package:fitness_log/views/setting.dart';
import 'package:flutter/material.dart';
import '../views/home_view.dart';
import '../views/profile_page.dart';

class Drawer_page extends StatelessWidget {
  const Drawer_page({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      backgroundColor: Colors.transparent,
      width: MediaQuery.of(context).size.width * 0.7,
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight),

          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(25),
                ),
                border: Border(
                  right: BorderSide(
                    color: colorScheme.outlineVariant.withOpacity(0.2),
                  ),
                ),
              ),
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      bottom: 20,
                      top: 10,
                    ),
                    child: Text(
                      "MENU",
                      style: TextStyle(
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary.withOpacity(0.7),
                      ),
                    ),
                  ),

                  _buildDrawerItem(
                    context,
                    icon: Icons.home_rounded,
                    label: "Accueil",
                    destination: const HomeView(),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.person_outline_rounded,
                    label: "Profil",
                    destination: const ProfilePage(),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.settings_outlined,
                    label: "Paramètres",
                    destination: const Setting(),
                  ),

                  const Divider(height: 40, indent: 20, endIndent: 20,),

                  Text(
                    "© 2025 Fitness Log",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Tous droits réservés",
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 0.5,
                      color: colorScheme.onSurface.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Widget destination,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
    );
  }
}
