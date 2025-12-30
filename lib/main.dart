
import 'package:fitness_log/core/theme/app_colors.dart';
import 'package:fitness_log/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'views/home_view.dart';
import 'views/dashboard_view.dart';
import 'views/list_view.dart' show WorkoutListView;
import 'views/add_workout_view.dart';
import 'models/workout.dart';

void main() {
  runApp(
    const ProviderScope(
      child: FitnessLogApp(),
    ),
  );
}

class FitnessLogApp extends ConsumerWidget  {
  const FitnessLogApp({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Fitness Log',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const MainNavigation(),
        '/add-workout': (context) {
          final workout = ModalRoute.of(context)?.settings.arguments as Workout?;
          return AddWorkoutView(workout: workout);
        },
        '/dashboard': (context) => const DashboardView(),
      },
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _views = [
    const DashboardView(),
    WorkoutListView(),
    const HomeView(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(

      body: _views[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.query_stats),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_list_rounded),
            label: 'Liste',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_sharp),
            label: 'Accueil',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/add-workout'),
        label: const Text("SÉANCE"),
        icon: Icon(Icons.add,color: isDark ?  AppColors.primary: Colors.white),
        backgroundColor: isDark ? Colors.white : AppColors.primary,
      ),

    );
  }
}
