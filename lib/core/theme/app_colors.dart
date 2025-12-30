import 'package:flutter/material.dart';

/// Palette de couleurs cohérente adaptée au sport
class AppColors {
  // Couleurs principales
  static const Color primary = Color(0xFF4420B9); // Bleu
  static const Color primaryDark = Color(0xFF475293);
  static const Color primaryLight = Color(0xFF38427A);

  // Couleurs secondaires
  static const Color secondary = Color(0x5C6BC0FF); // Vert
  static const Color secondaryDark = Color(0xFF388E3C);
  static const Color secondaryLight = Color(0xFF81C784);

  // Couleurs d'accent
  static const Color accent = Color(0xFFFF9800); // Orange
  static const Color accentDark = Color(0xFFF57C00);
  static const Color accentLight = Color(0xFFFFB74D);

  // Couleurs par type de sport
  static const Color cardioColor = Color(0xFFE91E1E); // Rose/Rouge
  static const Color musculationColor = Color(0xFF042D4B); // Violet
  static const Color marcheColor = Color(0xFF4CAF50); // Vert
  static const Color courseColor = Color(0xFF000000); // Rouge
  static const Color yogaColor = Color(0xFF00CDD4); // Cyan

  // Couleurs de statut
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Couleurs de fond
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // Couleurs de texte
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);

  /// Obtient la couleur associée à un type de sport
  static Color getSportColor(String typeSport) {
    switch (typeSport) {
      case 'Cardio':
        return cardioColor;
      case 'Musculation':
        return musculationColor;
      case 'Marche':
        return marcheColor;
      case 'Course':
        return courseColor;
      case 'Yoga':
        return yogaColor;
      default:
        return primary;
    }
  }
}

