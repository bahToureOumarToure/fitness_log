import 'package:flutter/material.dart';

/// Barre de progression générique (current/target)
class ProgressBar extends StatelessWidget {
  final double current;
  final double target;
  final String? label;
  final Color? color;
  final String? unit;

  const ProgressBar({
    super.key,
    required this.current,
    required this.target,
    this.label,
    this.color,
    this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final progress = target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;
    final progressColor = color ?? Theme.of(context).colorScheme.primary;
    final percentage = (progress * 100).toStringAsFixed(0);

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
                      fontWeight: FontWeight.w500,
                    ),
              ),
              Text(
                '$current${unit ?? ''} / $target${unit ?? ''} ($percentage%)',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Theme.of(context).colorScheme.surface,
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
          ),
        ),
      ],
    );
  }
}

