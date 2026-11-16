import '../../../../core/constants/app_strings.dart';

/// "اليوم", "أمس" or "قبل N أيام" for a stored date.
abstract final class DayLabel {
  static String of(DateTime date, {required DateTime now}) {
    final days = _dayOnly(now).difference(_dayOnly(date)).inDays;
    if (days <= 0) return AppStrings.today;
    if (days == 1) return AppStrings.yesterday;
    return '${AppStrings.daysAgoPrefix} $days ${AppStrings.days}';
  }

  static DateTime _dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);
}
