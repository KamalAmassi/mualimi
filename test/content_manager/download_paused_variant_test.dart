import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/features/content_manager/presentation/controllers/download_paused_variant.dart';
import 'package:mualimi/features/content_manager/presentation/controllers/download_ui_state.dart';
import 'package:mualimi/features/content_manager/presentation/controllers/pause_reason.dart';

void main() {
  test('a user pause waits for the user', () {
    expect(DownloadPausedVariant.of(DownloadUiState.paused, PauseReason.user), DownloadPausedVariant.user);
  });

  test('a pause with no reason is treated as a user pause', () {
    expect(DownloadPausedVariant.of(DownloadUiState.paused, null), DownloadPausedVariant.user);
  });

  test('a network pause waits for the network', () {
    expect(DownloadPausedVariant.of(DownloadUiState.paused, PauseReason.network), DownloadPausedVariant.network);
  });

  test('waiting for Wi-Fi wins over any reason', () {
    for (final reason in [null, ...PauseReason.values]) {
      expect(DownloadPausedVariant.of(DownloadUiState.waitingForWifi, reason), DownloadPausedVariant.wifi);
    }
  });
}
