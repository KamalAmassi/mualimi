import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../../../../core/constants/app_config.dart';
import '../../../../core/error/exceptions.dart';

abstract class ManifestRemoteDataSource {
  Future<Map<String, dynamic>> fetch();
}

class HttpManifestRemoteDataSource implements ManifestRemoteDataSource {
  HttpManifestRemoteDataSource({String url = AppConfig.manifestUrl}) : _url = url;
  final String _url;

  @override
  Future<Map<String, dynamic>> fetch() async {
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: AppConfig.httpTimeoutSeconds);
    try {
      final request = await client.getUrl(Uri.parse(_url));
      final response = await request.close();
      if (response.statusCode != HttpStatus.ok) {
        throw NetworkException('manifest HTTP ${response.statusCode}');
      }
      final body = await response.transform(utf8.decoder).join();
      return jsonDecode(body) as Map<String, dynamic>;
    } on SocketException catch (e) {
      throw NetworkException(e.message);
    } on TimeoutException {
      throw const NetworkException('manifest request timed out');
    } on FormatException catch (e) {
      throw ManifestException(e.message);
    } finally {
      client.close(force: true);
    }
  }
}
