import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class SslPinningClient extends http.BaseClient {
  static const certificatePath = 'certificates/certificates.pem';

  late final Future<http.Client> _client = _createClient();

  static Future<http.Client> _createClient() async {
    if (kIsWeb) return http.Client();

    final certificate = await rootBundle.load(certificatePath);
    final context = SecurityContext(withTrustedRoots: false)
      ..setTrustedCertificatesBytes(certificate.buffer.asUint8List());
    final httpClient = HttpClient(context: context)
      ..badCertificateCallback = (cert, host, port) => false;

    return IOClient(httpClient);
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final client = await _client;
    return client.send(request);
  }

  @override
  void close() {
    _client.then((client) => client.close());
  }
}
