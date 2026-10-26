import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

/// Error propio de la API: guarda el código HTTP y un mensaje legible.
class ApiException implements Exception {
  final int? statusCode;
  final String message;
  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

class ApiClient {
  static const _headers = {'Content-Type': 'application/json'};
  static const _timeout = Duration(seconds: 10);

  static Uri _uri(String path) => Uri.parse('${ApiConfig.baseUrl}$path');

  static Future<dynamic> get(String path) =>
      _send(() => http.get(_uri(path)));

  static Future<dynamic> post(String path, [Map<String, dynamic>? body]) =>
      _send(() => http.post(_uri(path),
          headers: _headers, body: jsonEncode(body ?? {})));

  static Future<dynamic> put(String path, Map<String, dynamic> body) =>
      _send(() => http.put(_uri(path),
          headers: _headers, body: jsonEncode(body)));

  static Future<dynamic> patch(String path, [Map<String, dynamic>? body]) =>
      _send(() => http.patch(_uri(path),
          headers: _headers, body: jsonEncode(body ?? {})));

  static Future<dynamic> delete(String path) =>
      _send(() => http.delete(_uri(path)));

  /// Ejecuta la petición con timeout y traduce los errores.
  static Future<dynamic> _send(Future<http.Response> Function() request) async {
    try {
      final r = await request().timeout(_timeout);
      return _handle(r);
    } on TimeoutException {
      throw ApiException('El servidor no responde. ¿Está encendido el backend?');
    } on http.ClientException {
      throw ApiException('No se pudo conectar con el servidor.');
    }
  }

  static dynamic _handle(http.Response r) {
    if (r.statusCode >= 200 && r.statusCode < 300) {
      return r.body.isEmpty ? null : jsonDecode(utf8.decode(r.bodyBytes));
    }
    if (r.statusCode == 400) {
      throw ApiException('Datos inválidos.', 400);
    }
    if (r.statusCode == 401 || r.statusCode == 403) {
      throw ApiException('No autorizado.', r.statusCode);
    }
    if (r.statusCode == 404) {
      throw ApiException('No encontrado.', 404);
    }
    throw ApiException('Error del servidor (${r.statusCode}).', r.statusCode);
  }
}