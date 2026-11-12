import 'package:equatable/equatable.dart';

enum TutorEngineKind {
  notDownloaded,
  downloading,
  paused,
  verifying,
  assembling,
  downloaded,
  loading,
  ready,
  failed,
  unsupported,
  searchOnly,
}

sealed class TutorEngineState extends Equatable {
  const TutorEngineState();

  TutorEngineKind get kind;

  @override
  List<Object?> get props => [kind];
}

class NotDownloaded extends TutorEngineState {
  const NotDownloaded();
  @override
  TutorEngineKind get kind => TutorEngineKind.notDownloaded;
}

class Downloading extends TutorEngineState {
  const Downloading({this.progress = 0, this.bytes = 0});

  /// 0..1 across all parts.
  final double progress;
  final int bytes;

  @override
  TutorEngineKind get kind => TutorEngineKind.downloading;
  @override
  List<Object?> get props => [kind, progress, bytes];
}

class Paused extends TutorEngineState {
  const Paused();
  @override
  TutorEngineKind get kind => TutorEngineKind.paused;
}

class Verifying extends TutorEngineState {
  const Verifying();
  @override
  TutorEngineKind get kind => TutorEngineKind.verifying;
}

class Assembling extends TutorEngineState {
  const Assembling();
  @override
  TutorEngineKind get kind => TutorEngineKind.assembling;
}

class Downloaded extends TutorEngineState {
  const Downloaded();
  @override
  TutorEngineKind get kind => TutorEngineKind.downloaded;
}

class Loading extends TutorEngineState {
  const Loading();
  @override
  TutorEngineKind get kind => TutorEngineKind.loading;
}

class Ready extends TutorEngineState {
  const Ready();
  @override
  TutorEngineKind get kind => TutorEngineKind.ready;
}

class Failed extends TutorEngineState {
  const Failed(this.reason);
  final String reason;

  @override
  TutorEngineKind get kind => TutorEngineKind.failed;
  @override
  List<Object?> get props => [kind, reason];
}

class Unsupported extends TutorEngineState {
  const Unsupported();
  @override
  TutorEngineKind get kind => TutorEngineKind.unsupported;
}

class SearchOnly extends TutorEngineState {
  const SearchOnly();
  @override
  TutorEngineKind get kind => TutorEngineKind.searchOnly;
}
