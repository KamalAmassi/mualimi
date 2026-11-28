import 'dart:io';

/// One part of the installed pack that a swap replaces: the live [target],
/// where it waits as [backup] during the swap, and its [staged] replacement.
class PackSwapEntry {
  const PackSwapEntry({
    required this.target,
    required this.backup,
    required this.staged,
  });

  final FileSystemEntity target;
  final FileSystemEntity backup;
  final FileSystemEntity staged;
}
