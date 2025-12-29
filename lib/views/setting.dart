import 'package:fitness_log/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Setting extends ConsumerWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themMode = ref.watch(themeProvider);
    return Scaffold(
      appBar: AppBar(title: Text("Setting"), centerTitle: true),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Mode sombre'),
            subtitle: const Text('Activer le mode sombre'),
            value: themMode == ThemeMode.dark,
            onChanged: (value) => {
              ref.read(themeProvider.notifier).toggleTheme(value),
            },
            secondary: Icon(Icons.dark_mode),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('À propos'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Fitness Log App',
                applicationVersion: '1.0.0',
              );
            },
          ),
        ],
      ),
    );
  }
}
