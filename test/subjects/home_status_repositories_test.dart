import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/services/connectivity_service.dart';
import 'package:mualimi/core/services/settings_service.dart';
import 'package:mualimi/features/subjects/data/repositories/network_status_repository_impl.dart';
import 'package:mualimi/features/subjects/data/repositories/student_repository_impl.dart';
import 'package:mualimi/features/subjects/domain/entities/student_summary.dart';

class _Connectivity extends Fake implements Connectivity {
  final changes = StreamController<List<ConnectivityResult>>.broadcast();

  @override
  Future<List<ConnectivityResult>> checkConnectivity() async => [ConnectivityResult.none];

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged => changes.stream;
}

Future<void> _flush() => Future<void>.delayed(Duration.zero);

void main() {
  test('student repository emits current values then edits', () async {
    final dir = await Directory.systemTemp.createTemp('home_student');
    addTearDown(() => dir.delete(recursive: true));
    final settings = await SettingsService(File('${dir.path}/settings.json')).init();
    await settings.setStudentName('أحمد');

    final seen = <StudentSummary>[];
    final sub = StudentRepositoryImpl(settings).watch().listen(seen.add);
    await _flush();
    await settings.setGrade(9);
    await settings.setStudentName('سلمى');
    await _flush();
    await sub.cancel();

    expect(seen.first, const StudentSummary(name: 'أحمد', grade: null));
    expect(seen.last, const StudentSummary(name: 'سلمى', grade: 9));
  });

  test('network repository emits current state then changes', () async {
    final plugin = _Connectivity();
    final service = await ConnectivityService(connectivity: plugin).init();

    final seen = <bool>[];
    final sub = NetworkStatusRepositoryImpl(service).watchOnline().listen(seen.add);
    await _flush();
    plugin.changes.add([ConnectivityResult.mobile]);
    await _flush();
    plugin.changes.add([ConnectivityResult.none]);
    await _flush();
    await sub.cancel();

    expect(seen, [false, true, false]);
  });
}
