import 'dart:io';

/// Everything [PackInstaller] needs from outside content_manager: where the
/// pack lives, how to close/reopen the content DB, and where the installed
/// version is recorded. Lets tests run the installer against a temp folder.
abstract class PackInstallHost {
  /// Root of all pack files. The installer never touches anything outside it.
  Directory get packsDir;

  File get contentDbFile;

  Directory get pdfDir;

  Future<void> closeContent();

  void openContent();

  int? get installedVersion;

  Future<void> setInstalledVersion(int? version);
}
