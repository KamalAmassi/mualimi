import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/error/exceptions.dart';
import 'package:mualimi/features/content_manager/data/datasources/manifest_remote_data_source.dart';

/// An [HttpClient] whose requests fail with [error] before any I/O happens.
class _ThrowingClient implements HttpClient {
  _ThrowingClient(this.error);
  final Object error;

  @override
  Future<HttpClientRequest> getUrl(Uri url) => Future.error(error);

  @override
  void close({bool force = false}) {}

  @override
  dynamic noSuchMethod(Invocation invocation) => null; // e.g. connectionTimeout=
}

void main() {
  HttpServer? server;
  late String url;

  Future<void> serve(FutureOr<void> Function(HttpRequest) handler) async {
    final s = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    server = s;
    url = 'http://${s.address.host}:${s.port}/manifest.json';
    s.listen(handler);
  }

  HttpManifestRemoteDataSource source({Duration timeout = const Duration(seconds: 5)}) =>
      HttpManifestRemoteDataSource(url: url, overallTimeout: timeout);

  tearDown(() async {
    await server?.close(force: true);
    server = null;
  });

  test('returns the decoded JSON object on 200', () async {
    await serve((r) => r.response
      ..write('{"schemaVersion":1,"packs":[]}')
      ..close());
    expect(await source().fetch(), {'schemaVersion': 1, 'packs': <dynamic>[]});
  });

  test('a stalled body becomes NetworkException within the timeout', () async {
    await serve((r) {
      r.response
        ..contentLength = 1000
        ..write('{"schemaVersion":'); // never finishes
      return r.response.flush();
    });
    final watch = Stopwatch()..start();
    await expectLater(
      source(timeout: const Duration(milliseconds: 300)).fetch(),
      throwsA(isA<NetworkException>()),
    );
    expect(watch.elapsed, lessThan(const Duration(seconds: 3)));
  });

  test('non-200 status becomes NetworkException', () async {
    await serve((r) => r.response
      ..statusCode = HttpStatus.serviceUnavailable
      ..write('down')
      ..close());
    await expectLater(source().fetch(), throwsA(isA<NetworkException>()));
  });

  test('malformed JSON becomes ManifestException', () async {
    await serve((r) => r.response
      ..write('{not json')
      ..close());
    await expectLater(source().fetch(), throwsA(isA<ManifestException>()));
  });

  test('a JSON array (not an object) becomes ManifestException', () async {
    await serve((r) => r.response
      ..write('[1,2]')
      ..close());
    await expectLater(source().fetch(), throwsA(isA<ManifestException>()));
  });

  group('transport errors become NetworkException', () {
    final errors = <String, Object>{
      'HandshakeException': const HandshakeException('bad cert'),
      'HttpException': const HttpException('connection closed'),
      'SocketException': const SocketException('no route'),
      'FileSystemException (other IOException)': const FileSystemException('io'),
      'TimeoutException': TimeoutException('connect'),
    };
    errors.forEach((name, error) {
      test(name, () async {
        final s = HttpManifestRemoteDataSource(
          url: 'http://127.0.0.1/manifest.json',
          clientFactory: () => _ThrowingClient(error),
        );
        await expectLater(s.fetch(), throwsA(isA<NetworkException>()));
      });
    });
  });
}
