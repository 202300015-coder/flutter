import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/movie_model.dart';
import '../services/movie_client.dart';

class ApiCrudPage extends StatefulWidget {
  const ApiCrudPage({super.key});

  @override
  State<ApiCrudPage> createState() => _ApiCrudPageState();
}

class _ApiCrudPageState extends State<ApiCrudPage> {
  final MovieClient _movieClient = MovieClient();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _posterUrlController = TextEditingController();
  final TextEditingController _imdbIdController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _genresController = TextEditingController();
  final TextEditingController _consoleController = TextEditingController();

  bool _isLoading = false;
  List<MovieModel> _movies = <MovieModel>[];

  @override
  void dispose() {
    _movieClient.dispose();
    _idController.dispose();
    _titleController.dispose();
    _posterUrlController.dispose();
    _imdbIdController.dispose();
    _yearController.dispose();
    _genresController.dispose();
    _consoleController.dispose();
    super.dispose();
  }

  Future<void> _executeRequest(Future<dynamic> Function() action) async {
    setState(() {
      _isLoading = true;
      _consoleController.text = 'Procesando solicitud...';
    });

    try {
      final result = await action();
      _applyResult(result);
    } catch (error) {
      _consoleController.text = 'Error: $error';
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$error')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _applyResult(dynamic result) {
    if (result is List<MovieModel>) {
      setState(() {
        _movies = result;
      });
      _consoleController.text = const JsonEncoder.withIndent('  ').convert(
        result.map((movie) => movie.toJson()).toList(),
      );
      return;
    }

    if (result is MovieModel) {
      _seedForm(result);
      _consoleController.text = const JsonEncoder.withIndent('  ').convert(
        result.toJson(),
      );
      return;
    }

    _consoleController.text = result?.toString() ?? 'Sin resultado.';
  }

  void _seedForm(MovieModel movie) {
    _idController.text = movie.id?.toString() ?? _idController.text;
    _titleController.text = movie.title;
    _posterUrlController.text = movie.posterUrl ?? '';
    _imdbIdController.text = movie.imdbId ?? '';
    _yearController.text = movie.year?.toString() ?? '';
    _genresController.text = movie.genres?.join(', ') ?? '';
  }

  MovieModel _buildMovieFromForm({bool includeId = false}) {
    return MovieModel(
      id: includeId ? int.tryParse(_idController.text.trim()) : null,
      title: _titleController.text.trim().isEmpty
          ? 'Untitled Horror Movie'
          : _titleController.text.trim(),
      posterUrl: _posterUrlController.text.trim().isEmpty
          ? null
          : _posterUrlController.text.trim(),
      imdbId: _imdbIdController.text.trim().isEmpty
          ? null
          : _imdbIdController.text.trim(),
      year: int.tryParse(_yearController.text.trim()),
      genres: _genresController.text.trim().isEmpty
          ? null
          : _genresController.text
              .split(',')
              .map((item) => item.trim())
              .where((item) => item.isNotEmpty)
              .toList(),
    );
  }

  Widget _buildActionButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: _isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF7A1111),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Text(label),
    );
  }

  Widget _buildInfoField({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: Color(0xFFF0D6B6)),
        hintStyle: const TextStyle(color: Color(0xFFB6A28B)),
        filled: true,
        fillColor: const Color(0xFF1A1A1F),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F13),
      appBar: AppBar(
        title: const Text('REST Client CRUD'),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A1A1F),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF111114),
              Color(0xFF1A1010),
              Color(0xFF0E0E12),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _buildActionButton('GET /movies', () {
                      _executeRequest(() => _movieClient.getMovies());
                    }),
                    _buildActionButton('GET /movies/:id', () {
                      final id = int.tryParse(_idController.text.trim());
                      if (id == null) {
                        setState(() {
                          _consoleController.text = 'Ingresa un ID válido antes de consultar.';
                        });
                        return;
                      }

                      _executeRequest(() => _movieClient.getMovieById(id));
                    }),
                    _buildActionButton('POST', () {
                      _executeRequest(() => _movieClient.createMovie(
                            _buildMovieFromForm(),
                          ));
                    }),
                    _buildActionButton('PUT', () {
                      final id = int.tryParse(_idController.text.trim());
                      if (id == null) {
                        setState(() {
                          _consoleController.text = 'Ingresa un ID válido antes de actualizar.';
                        });
                        return;
                      }

                      _executeRequest(() => _movieClient.updateMovie(
                            id,
                            _buildMovieFromForm(includeId: true),
                          ));
                    }),
                    _buildActionButton('PATCH', () {
                      final id = int.tryParse(_idController.text.trim());
                      if (id == null) {
                        setState(() {
                          _consoleController.text = 'Ingresa un ID válido antes de aplicar PATCH.';
                        });
                        return;
                      }

                      final changes = <String, dynamic>{
                        'title': _titleController.text.trim(),
                        if (_posterUrlController.text.trim().isNotEmpty)
                          'posterURL': _posterUrlController.text.trim(),
                        if (_imdbIdController.text.trim().isNotEmpty)
                          'imdbId': _imdbIdController.text.trim(),
                        if (_yearController.text.trim().isNotEmpty)
                          'year': int.tryParse(_yearController.text.trim()),
                        if (_genresController.text.trim().isNotEmpty)
                          'genres': _genresController.text
                              .split(',')
                              .map((item) => item.trim())
                              .where((item) => item.isNotEmpty)
                              .toList(),
                      };

                      _executeRequest(() => _movieClient.patchMovie(id, changes));
                    }),
                    _buildActionButton('DELETE', () {
                      final id = int.tryParse(_idController.text.trim());
                      if (id == null) {
                        setState(() {
                          _consoleController.text = 'Ingresa un ID válido antes de eliminar.';
                        });
                        return;
                      }

                      _executeRequest(() => _movieClient.deleteMovie(id));
                    }),
                    _buildActionButton('TODOS', () {
                      _executeRequest(() => _movieClient.getMovies());
                    }),
                  ],
                ),
                const SizedBox(height: 20),
                Card(
                  color: const Color(0xFF19191F),
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Formulario rápido',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 14),
                        _buildInfoField(
                          controller: _idController,
                          label: 'ID',
                          hint: 'Ej. 1',
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 12),
                        _buildInfoField(
                          controller: _titleController,
                          label: 'Title',
                          hint: 'Nombre de la película',
                        ),
                        const SizedBox(height: 12),
                        _buildInfoField(
                          controller: _posterUrlController,
                          label: 'Poster URL',
                          hint: 'https://...',
                        ),
                        const SizedBox(height: 12),
                        _buildInfoField(
                          controller: _imdbIdController,
                          label: 'IMDb ID',
                          hint: 'tt1234567',
                        ),
                        const SizedBox(height: 12),
                        _buildInfoField(
                          controller: _yearController,
                          label: 'Year',
                          hint: '2024',
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 12),
                        _buildInfoField(
                          controller: _genresController,
                          label: 'Genres',
                          hint: 'Horror, Thriller',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  color: const Color(0xFF14141A),
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Consola de resultados',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            if (_isLoading)
                              const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                  color: Color(0xFFE5B95B),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ConstrainedBox(
                          constraints: const BoxConstraints(minHeight: 180),
                          child: SingleChildScrollView(
                            child: TextField(
                              controller: _consoleController,
                              maxLines: null,
                              readOnly: true,
                              style: const TextStyle(
                                color: Color(0xFFF2D8B3),
                                fontFamily: 'monospace',
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFF101014),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: 'Aquí aparecerá la respuesta de la API.',
                                hintStyle: const TextStyle(
                                  color: Color(0xFF8B7D6E),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  color: const Color(0xFF18181E),
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Películas cargadas',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (_movies.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Text(
                              'La lista se mostrará aquí cuando uses GET /movies o TODOS.',
                              style: TextStyle(color: Color(0xFFC9B8A6)),
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _movies.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final movie = _movies[index];
                              return InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () => _seedForm(movie),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF101014),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.white12,
                                    ),
                                  ),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: const Color(0xFF7A1111),
                                      child: Text(
                                        movie.id?.toString() ?? '?',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      movie.title,
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    subtitle: Text(
                                      [
                                        if (movie.year != null) movie.year.toString(),
                                        if (movie.imdbId != null) movie.imdbId!,
                                      ].join(' · '),
                                      style: const TextStyle(
                                        color: Color(0xFFC9B8A6),
                                      ),
                                    ),
                                    trailing: movie.posterUrl == null
                                        ? null
                                        : const Icon(
                                            Icons.image_outlined,
                                            color: Color(0xFFE5B95B),
                                          ),
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}