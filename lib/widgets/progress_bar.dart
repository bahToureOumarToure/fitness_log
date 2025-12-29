import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double current;
  final double target;
  final String? label;
  final String? unit;

  const ProgressBar({
    super.key,
    required this.current,
    required this.target,
    this.label,
    this.unit,
  });

  // Logique de couleur selon vos règles : <70% Vert, 70-100% Orange, >100% Rouge
  Color _getStatusColor(double percentageValue) {
    if (percentageValue < 70) return Colors.green;
    if (percentageValue <= 100) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    // Calcul du ratio pour la barre (bridé entre 0 et 1 pour l'affichage)
    final progress = target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;

    // Calcul du pourcentage réel (peut dépasser 100 pour la couleur)
    final realPercentage = target > 0 ? (current / target) * 100 : 0.0;

    // Application de la couleur dynamique
    final dynamicColor = _getStatusColor(realPercentage);

    final percentageLabel = realPercentage.toStringAsFixed(0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: dynamicColor, // Le label prend aussi la couleur
                ),
              ),
              Text(
                '${current.toStringAsFixed(1)}${unit ?? ''} / $target${unit ?? ''} ($percentageLabel%)',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: dynamicColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(dynamicColor),
          ),
        ),
      ],
    );
  }
}