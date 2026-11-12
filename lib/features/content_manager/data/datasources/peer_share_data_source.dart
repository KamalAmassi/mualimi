import 'dart:io';

import '../../domain/entities/artifact_info.dart';
import '../../domain/entities/download_progress.dart';
import '../../domain/entities/peer_device.dart';

/// Phone-to-phone model sharing (Nearby Connections / Wi-Fi Direct).
///
/// TODO(peer-share): interface only. Needs a transport package (not in the
/// fixed stack), platform permissions, and a pairing UX before it can be built.
abstract class PeerShareDataSource {
  bool get isSupported;
  Stream<PeerDevice> discover();
  Stream<DownloadProgress> receive(ArtifactInfo artifact, PeerDevice from, {required File target});
}

class UnavailablePeerShareDataSource implements PeerShareDataSource {
  @override
  bool get isSupported => false;

  @override
  Stream<PeerDevice> discover() => const Stream.empty();

  @override
  Stream<DownloadProgress> receive(ArtifactInfo artifact, PeerDevice from, {required File target}) =>
      Stream.error(UnsupportedError('Peer sharing is not implemented yet'));
}
