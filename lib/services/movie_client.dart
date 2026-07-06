import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/movie_model.dart';

class MovieClient {
  MovieClient({http.Client? client}) : _client = client ?? http.Client();

  static const String baseUrl = 'https://api.sampleapis.com/movies/horror';

  final http.Client _client;

  Uri _buildUri([String path = '']) {
    return Uri.parse('$baseUrl$path');
  }

  Future<List<MovieModel>> getMovies() {
    return _sendRequest<List<MovieModel>>(
      method: 'GET',
      uri: _buildUri(),
      parser: (dynamic jsonBody) {
        final movies = jsonBody as List<dynamic>;
        return movies
            .map((item) => MovieModel.fromJson(item as Map<String, dynamic>))
            .toList();
      },
    );
  }

  Future<MovieModel> getMovieById(int id) {
    return _sendRequest<MovieModel>(
      method: 'GET',
      uri: _buildUri('/$id'),
      parser: (dynamic jsonBody) =>
          MovieModel.fromJson(jsonBody as Map<String, dynamic>),
    );
  }

  Future<MovieModel> createMovie(MovieModel movie) {
    return _sendRequest<MovieModel>(
      method: 'POST',
      uri: _buildUri(),
      body: movie.toJson(),
      parser: (dynamic jsonBody) =>
          MovieModel.fromJson(jsonBody as Map<String, dynamic>),
    );
  }

  Future<MovieModel> updateMovie(int id, MovieModel movie) {
    return _sendRequest<MovieModel>(
      method: 'PUT',
      uri: _buildUri('/$id'),
      body: movie.toJson(),
      parser: (dynamic jsonBody) =>
          MovieModel.fromJson(jsonBody as Map<String, dynamic>),
    );
  }

  Future<MovieModel> patchMovie(int id, Map<String, dynamic> changes) {
    return _sendRequest<MovieModel>(
      method: 'PATCH',
      uri: _buildUri('/$id'),
      body: changes,
      parser: (dynamic jsonBody) =>
          MovieModel.fromJson(jsonBody as Map<String, dynamic>),
    );
  }

  Future<String> deleteMovie(int id) {
    return _sendRequest<String>(
      method: 'DELETE',
      uri: _buildUri('/$id'),
      parser: (dynamic jsonBody) {
        if (jsonBody == null) {
          return 'Película eliminada correctamente.';
        }

        return jsonEncode(jsonBody);
      },
    );
  }

  Future<T> _sendRequest<T>({
    required String method,
    required Uri uri,
    required T Function(dynamic jsonBody) parser,
    Object? body,
  }) async {
    try {
      final request = http.Request(method, uri);
      request.headers['Accept'] = 'application/json';

      if (body != null) {
        request.headers['Content-Type'] = 'application/json; charset=utf-8';
        request.body = jsonEncode(body);
      }

      final streamedResponse = await _client.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isEmpty) {
          return parser(null);
        }

        final dynamic decodedBody = jsonDecode(response.body);
        return parser(decodedBody);
      }

      throw _buildHttpException(response);
    } on SocketException {
      throw Exception('No hay conexión a internet.');
    } on FormatException {
      throw Exception('La respuesta de la API no es válida.');
    } catch (error) {
      throw Exception('Error al ejecutar $method $uri: $error');
    }
  }

  Exception _buildHttpException(http.Response response) {
    final message = switch (response.statusCode) {
      400 => 'Solicitud inválida.',
      401 => 'No autorizado para completar la operación.',
      403 => 'Acceso denegado por la API.',
      404 => 'La película solicitada no existe.',
      500 => 'La API respondió con un error interno.',
      _ => 'Error HTTP ${response.statusCode}: ${response.reasonPhrase ?? 'sin detalle'}',
    };

    return Exception(message);
  }

  void dispose() {
    _client.close();
  }
}