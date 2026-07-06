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
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _posterUrlController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _genresController = TextEditingController();
  final TextEditingController _consoleController = TextEditingController();
  final ScrollController _moviesScrollController = ScrollController();

  bool _isLoading = false;
  List<MovieModel> _movies = <MovieModel>[];
  MovieModel? _selectedMovie;

  @override
  void dispose() {
    _movieClient.dispose();
    _titleController.dispose();
    _posterUrlController.dispose();
    _yearController.dispose();
    _genresController.dispose();
    _consoleController.dispose();
    _moviesScrollController.dispose();
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
    if (_selectedMovie?.id == movie.id) {
      _clearSelection();
      return;
    }

    _selectedMovie = movie;
    _titleController.text = movie.title;
    _posterUrlController.text = movie.posterUrl ?? '';
    _yearController.text = movie.year?.toString() ?? '';
    _genresController.text = movie.genres?.join(', ') ?? '';
  }

  void _clearSelection() {
    setState(() {
      _selectedMovie = null;
      _titleController.clear();
      _posterUrlController.clear();
      _yearController.clear();
      _genresController.clear();
      _consoleController.text = 'Selección limpia. Puedes elegir otra película o crear una nueva.';
    });
  }

  MovieModel _buildMovieFromForm() {
    return MovieModel(
      title: _titleController.text.trim().isEmpty
          ? 'Untitled Horror Movie'
          : _titleController.text.trim(),
      posterUrl: _posterUrlController.text.trim().isEmpty
          ? null
          : _posterUrlController.text.trim(),
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

  int? get _selectedMovieId => _selectedMovie?.id;

  bool _requireSelectedMovie(String actionLabel) {
    if (_selectedMovieId == null) {
      _consoleController.text = 'Selecciona una película de la lista antes de usar $actionLabel.';
      return false;
    }

    return true;
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
          child: Padding(
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
                    _buildActionButton('POST', () {
                      _executeRequest(() => _movieClient.createMovie(
                            _buildMovieFromForm(),
                          ));
                    }),
                    _buildActionButton('PUT', () {
                      if (!_requireSelectedMovie('PUT')) {
                        setState(() {});
                        return;
                      }

                      _executeRequest(() => _movieClient.updateMovie(
                            _selectedMovieId!,
                            _buildMovieFromForm(),
                          ));
                    }),
                    _buildActionButton('PATCH', () {
                      if (!_requireSelectedMovie('PATCH')) {
                        setState(() {});
                        return;
                      }

                      final changes = <String, dynamic>{
                        'title': _titleController.text.trim(),
                        if (_posterUrlController.text.trim().isNotEmpty)
                          'posterURL': _posterUrlController.text.trim(),
                        if (_yearController.text.trim().isNotEmpty)
                          'year': int.tryParse(_yearController.text.trim()),
                        if (_genresController.text.trim().isNotEmpty)
                          'genres': _genresController.text
                              .split(',')
                              .map((item) => item.trim())
                              .where((item) => item.isNotEmpty)
                              .toList(),
                      };

                      _executeRequest(() => _movieClient.patchMovie(
                            _selectedMovieId!,
                            changes,
                          ));
                    }),
                    _buildActionButton('DELETE', () {
                      if (!_requireSelectedMovie('DELETE')) {
                        setState(() {});
                        return;
                      }

                      _executeRequest(() => _movieClient.deleteMovie(_selectedMovieId!));
                    }),
                  ],
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final bool isWide = constraints.maxWidth >= 1000;

                      final Widget formPanel = _buildFormPanel();
                      final Widget moviesPanel = _buildMoviesPanel();

                      if (isWide) {
                        return Row(
                          children: [
                            SizedBox(
                              width: constraints.maxWidth * 0.38,
                              child: formPanel,
                            ),
                            const SizedBox(width: 16),
                            Container(
                              width: 6,
                              margin: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white12,
                                borderRadius: BorderRadius.circular(99),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(child: moviesPanel),
                          ],
                        );
                      }

                      return Column(
                        children: [
                          Expanded(child: formPanel),
                          const SizedBox(height: 16),
                          Expanded(child: moviesPanel),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormPanel() {
    return Card(
      color: const Color(0xFF19191F),
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Formulario rápido',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  if (_selectedMovie != null)
                    Text(
                      'Seleccionada: ${_selectedMovie!.id ?? '-'}',
                      style: const TextStyle(
                        color: Color(0xFFE5B95B),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: _clearSelection,
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text('Quitar selección'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFF2D8B3),
                    ),
                  ),
                ],
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
              const SizedBox(height: 12),
              TextField(
                controller: _consoleController,
                maxLines: 7,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoviesPanel() {
    return Card(
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
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Películas cargadas',
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
            Expanded(
              child: _movies.isEmpty
                  ? const Center(
                      child: Text(
                        'La lista se mostrará aquí cuando uses GET /movies.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFFC9B8A6)),
                      ),
                    )
                  : Scrollbar(
                      controller: _moviesScrollController,
                      thickness: 10,
                      radius: const Radius.circular(12),
                      trackVisibility: true,
                      thumbVisibility: true,
                      interactive: true,
                      scrollbarOrientation: ScrollbarOrientation.right,
                      notificationPredicate: (notification) => notification.depth == 0,
                      child: ListView.separated(
                        controller: _moviesScrollController,
                        itemCount: _movies.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          return _buildMovieCard(_movies[index]);
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieCard(MovieModel movie) {
    final bool isSelected = movie.id != null && movie.id == _selectedMovieId;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => setState(() => _seedForm(movie)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF221417) : const Color(0xFF101014),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? const Color(0xFFE5B95B) : Colors.white12,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                width: 60,
                height: 84,
                child: movie.posterUrl == null || movie.posterUrl!.isEmpty
                    ? Container(
                        color: const Color(0xFF7A1111),
                        alignment: Alignment.center,
                        child: Text(
                          movie.id?.toString() ?? '?',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : Image.network(
                        movie.posterUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) {
                          return Container(
                            color: const Color(0xFF7A1111),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.movie,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          movie.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle,
                          color: Color(0xFFE5B95B),
                          size: 18,
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    movie.id == null ? 'Sin ID' : 'ID ${movie.id}',
                    style: const TextStyle(
                      color: Color(0xFFF0D6B6),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    [
                      if (movie.year != null) movie.year.toString(),
                      if (movie.genres != null && movie.genres!.isNotEmpty) movie.genres!.join(', '),
                    ].join(' · '),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFFC9B8A6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}