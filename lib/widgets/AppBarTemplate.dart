import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/theme_provider.dart';
import '../views/notifier_page.dart';
import '../views/profile_page.dart';

class AppBartemplate extends ConsumerWidget implements PreferredSizeWidget {
  final String title;

  const AppBartemplate({required this.title, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final Color iconColor = isDark ? Colors.white : Colors.indigo.shade400;

    return AppBar(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      scrolledUnderElevation: 2,
      centerTitle: false,

      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
          fontSize: 15,
          color: colorScheme.onSurface,
        ),
      ),

      leadingWidth: 48,
      leading: Builder(
        builder: (context) => Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: Icon(Icons.format_align_left_rounded, color: iconColor),
          ),
        ),
      ),

      actions: [
        IconButton(
          icon: Icon(Icons.account_circle_outlined, size: 22, color: iconColor),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            );
          },
        ),

        IconButton(
          onPressed: () => ref.read(themeProvider.notifier).toggleTheme(!isDark),
          icon: Icon(
            isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            color: isDark ? Colors.amber[400] : Colors.indigo[400],
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.notifications_none_rounded, size: 24, color: iconColor),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NotifierPage()),
                  );
                },
              ),
              Positioned(
                top: 14,
                right: 14,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],

      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: colorScheme.outlineVariant.withOpacity(0.3),
          height: 1.0,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

