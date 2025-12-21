import 'package:intl/intl.dart';

/// Utilitaires de formatage de dates
class DateUtils {
  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  static final DateFormat _dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm');
  static final DateFormat _timeFormat = DateFormat('HH:mm');

  /// Formate une date au format dd/MM/yyyy
  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }

  /// Formate une date avec l'heure
  static String formatDateTime(DateTime dateTime) {
    return _dateTimeFormat.format(dateTime);
  }

  /// Formate uniquement l'heure
  static String formatTime(DateTime dateTime) {
    return _timeFormat.format(dateTime);
  }

  /// Obtient le début et la fin d'une semaine pour une date donnée
  /// Retourne le lundi et le dimanche de la semaine
  static Map<String, DateTime> getWeekRange(DateTime date) {
    final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    
    return {
      'start': DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day),
      'end': DateTime(
        endOfWeek.year,
        endOfWeek.month,
        endOfWeek.day,
        23,
        59,
        59,
      ),
    };
  }

  /// Obtient la semaine actuelle
  static Map<String, DateTime> getCurrentWeek() {
    return getWeekRange(DateTime.now());
  }

  /// Vérifie si deux dates sont dans la même semaine
  static bool isSameWeek(DateTime date1, DateTime date2) {
    final week1 = getWeekRange(date1);
    final week2 = getWeekRange(date2);
    return week1['start'] == week2['start'];
  }

  /// Obtient le nombre de jours entre deux dates
  static int daysBetween(DateTime start, DateTime end) {
    return end.difference(start).inDays;
  }

  /// Obtient le nombre de semaines entre deux dates
  static int weeksBetween(DateTime start, DateTime end) {
    return (daysBetween(start, end) / 7).ceil();
  }
}

