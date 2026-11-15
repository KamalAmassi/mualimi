import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../../../../core/constants/app_config.dart';
import '../../../../core/error/exceptions.dart';
import 'manifest_timing.dart';

abstract class ManifestRemoteDataSource {
  /// Throws [NetworkException] for any transport failure or non-200 status,
  /// and [ManifestException] when the body is not a JSON object.
  Future<Map<String, dynamic>> fetch();
}

class HttpManifestRemoteDataSource implements ManifestRemoteDataSource {
  HttpManifestRemoteDataSource({
    String url = AppConfig.manifestUrl,
    HttpClient Function()? clientFactory,
    Duration overallTimeout = ManifestTiming.overallTimeout,
  })  : _url = url,
        _clientFactory = clientFactory ?? HttpClient.new,
        _overallTimeout = overallTimeout;

  final String _url;
  final HttpClient Function() _clientFactory;
  final Duration _overallTimeout;

  @override
  Future<Map<String, dynamic>> fetch() async {
    final client = _clientFactory()
      ..connectionTimeout = const Duration(seconds: AppConfig.httpTimeoutSeconds);
    try {
      final body = await _download(client).timeout(_overallTimeout);
      final decoded = jsonDecode(body);
      if (decoded is! Map<String, dynamic>) {
        throw const ManifestException('manifest is not a JSON object');
      }
      return decoded;
    } on TimeoutException {
      throw const NetworkException('manifest request timed out');
    } on IOException catch (e) {
      // SocketException, HttpException, HandshakeException, other IO errors.
      throw NetworkException('manifest transport error: $e');
    } on FormatException catch (e) {
      throw ManifestException(e.message);
    } finally {
      client.close(force: true); // also aborts a stalled request on timeout
    }
  }

  Future<String> _download(HttpClient client) async {
    final request = await client.getUrl(Uri.parse(_url));
    final response = await request.close();
    if (response.statusCode != HttpStatus.ok) {
      await response.drain<void>().catchError((_) {});
      throw NetworkException('manifest HTTP ${response.statusCode}');
    }
    return response.transform(utf8.decoder).join();
  }
}
