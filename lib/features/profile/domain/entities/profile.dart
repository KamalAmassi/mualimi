import 'package:equatable/equatable.dart';

import 'app_theme_mode.dart';

class Profile extends Equatable {
  const Profile({required this.name, required this.grade, required this.themeMode});

  final String name;
  final int? grade;
  final AppThemeMode themeMode;

  @override
  List<Object?> get props => [name, grade, themeMode];
}
