import 'package:equatable/equatable.dart';

/// Where the diagnostic was opened from; it decides where it ends.
enum DiagnosticEntry { onboarding, profile }

/// Arguments of `AppRoutes.diagnostic`.
class DiagnosticArgs extends Equatable {
  const DiagnosticArgs({required this.entry});

  final DiagnosticEntry entry;

  /// Reads route arguments; a missing or foreign value means the profile
  /// entry, the one that simply returns to the previous screen.
  static DiagnosticArgs from(Object? arguments) => arguments is DiagnosticArgs
      ? arguments
      : const DiagnosticArgs(entry: DiagnosticEntry.profile);

  @override
  List<Object?> get props => [entry];
}
