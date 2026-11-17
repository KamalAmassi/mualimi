import 'package:equatable/equatable.dart';

import 'app_theme_mode.dart';

class Profile extends Equatable {
  const Profile({
    required this.name,
    required this.grade,
    required this.themeMode,
    this.fontScale = 1.0,
    this.packVersion,
  });

  final String name;
  final int? grade;
  final AppThemeMode themeMode;
  final double fontScale;

  /// Null until a pack is installed.
  final int? packVersion;

  @override
  List<Object?> get props => [name, grade, themeMode, fontScale, packVersion];
}
