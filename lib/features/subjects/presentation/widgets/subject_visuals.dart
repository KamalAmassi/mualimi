import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import 'home_strings.dart';

/// How a subject looks on Home, chosen by `subjects.id`: a text glyph or an icon.
class SubjectVisual {
  const SubjectVisual({required this.color, this.glyph, this.icon});

  final Color Function(AppColors colors) color;
  final String? glyph;
  final IconData? icon;

  static SubjectVisual of(String subjectId) => _byId[subjectId] ?? _fallback;

  static final _fallback = SubjectVisual(color: (c) => c.primary, icon: LucideIcons.bookOpen);

  static final Map<String, SubjectVisual> _byId = {
    'arabic': SubjectVisual(color: (c) => c.subjectArabic, glyph: HomeStrings.arabicGlyph),
    'english': SubjectVisual(color: (c) => c.subjectEnglish, glyph: HomeStrings.englishGlyph),
    'math': SubjectVisual(color: (c) => c.subjectMath, glyph: HomeStrings.mathGlyph),
    'science': SubjectVisual(color: (c) => c.subjectScience, icon: LucideIcons.flaskConical),
    'islamic': SubjectVisual(color: (c) => c.subjectIslamic, icon: LucideIcons.moon),
    'history': SubjectVisual(color: (c) => c.subjectHistory, icon: LucideIcons.landmark),
    'geography': SubjectVisual(color: (c) => c.subjectGeography, icon: LucideIcons.globe),
    'technology': SubjectVisual(color: (c) => c.subjectTech, icon: LucideIcons.cpu),
  };
}
