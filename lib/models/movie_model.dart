class MovieModel {
  const MovieModel({
    this.id,
    required this.title,
    this.posterUrl,
    this.imdbId,
    this.year,
    this.genres,
    this.director,
    this.actors,
    this.rating,
    this.plot,
    this.rated,
    this.runtime,
  });

  final int? id;
  final String title;
  final String? posterUrl;
  final String? imdbId;
  final int? year;
  final List<String>? genres;
  final String? director;
  final List<String>? actors;
  final double? rating;
  final String? plot;
  final String? rated;
  final String? runtime;

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: _toInt(json['id']),
      title: (json['title'] ?? '').toString(),
      posterUrl: (json['posterURL'] ?? json['posterUrl'])?.toString(),
      imdbId: json['imdbId']?.toString(),
      year: _toInt(json['year']),
      genres: _toStringList(json['genres']),
      director: json['director']?.toString(),
      actors: _toStringList(json['actors']),
      rating: _toDouble(json['rating']),
      plot: json['plot']?.toString(),
      rated: json['rated']?.toString(),
      runtime: json['runtime']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (id != null) 'id': id,
      'title': title,
      if (posterUrl != null) 'posterURL': posterUrl,
      if (imdbId != null) 'imdbId': imdbId,
      if (year != null) 'year': year,
      if (genres != null) 'genres': genres,
      if (director != null) 'director': director,
      if (actors != null) 'actors': actors,
      if (rating != null) 'rating': rating,
      if (plot != null) 'plot': plot,
      if (rated != null) 'rated': rated,
      if (runtime != null) 'runtime': runtime,
    };
  }

  MovieModel copyWith({
    int? id,
    String? title,
    String? posterUrl,
    String? imdbId,
    int? year,
    List<String>? genres,
    String? director,
    List<String>? actors,
    double? rating,
    String? plot,
    String? rated,
    String? runtime,
  }) {
    return MovieModel(
      id: id ?? this.id,
      title: title ?? this.title,
      posterUrl: posterUrl ?? this.posterUrl,
      imdbId: imdbId ?? this.imdbId,
      year: year ?? this.year,
      genres: genres ?? this.genres,
      director: director ?? this.director,
      actors: actors ?? this.actors,
      rating: rating ?? this.rating,
      plot: plot ?? this.plot,
      rated: rated ?? this.rated,
      runtime: runtime ?? this.runtime,
    );
  }

  static int? _toInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is double) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value);
    }

    return null;
  }

  static double? _toDouble(dynamic value) {
    if (value is double) {
      return value;
    }

    if (value is int) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value);
    }

    return null;
  }

  static List<String>? _toStringList(dynamic value) {
    if (value is List) {
      return value.map((item) => item.toString()).toList();
    }

    if (value is String && value.isNotEmpty) {
      return value
          .split(',')
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .toList();
    }

    return null;
  }
}