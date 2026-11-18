import 'dart:async';

import '../../../../core/services/settings_service.dart';
import '../../domain/entities/student_summary.dart';
import '../../domain/repositories/student_repository.dart';

class StudentRepositoryImpl implements StudentRepository {
  StudentRepositoryImpl(this._settings);
  final SettingsService _settings;

  StudentSummary get _current =>
      StudentSummary(name: _settings.studentName.value, grade: _settings.grade.value);

  @override
  Stream<StudentSummary> watch() {
    late final StreamController<StudentSummary> controller;
    final subscriptions = <StreamSubscription<Object?>>[];
    controller = StreamController<StudentSummary>(
      onListen: () {
        controller.add(_current);
        void emit(Object? _) => controller.add(_current);
        subscriptions
          ..add(_settings.studentName.listen(emit))
          ..add(_settings.grade.listen(emit));
      },
      onCancel: () => Future.wait(subscriptions.map((s) => s.cancel())),
    );
    return controller.stream;
  }
}
