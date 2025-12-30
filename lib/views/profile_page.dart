import 'package:fitness_log/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> profiles = ["HORTICE SEDJRO AUBED Adognibo", "ENGAR Aymen", "EL MAGHRAOUI Ismael","Omar Bah Touré"];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profils"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // En-tête de la page
          const CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.group, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 10),
          const Text(
            "L'équipage Fitness Log",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Liste des profils
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: profiles.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: Text(
                        profiles[index][0],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      profiles[index],
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: const Text("Développeurs Flutter"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}