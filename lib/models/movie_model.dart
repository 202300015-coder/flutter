class MovieModel {
  const MovieModel({
    this.id,
    required this.title,
    this.posterUrl,
    this.imdbId,
  });

  final int? id;
  final String title;
  final String? posterUrl;
  final String? imdbId;

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: _toInt(json['id']),
      title: (json['title'] ?? '').toString(),
      posterUrl: (json['posterURL'] ?? json['posterUrl'])?.toString(),
      imdbId: json['imdbId']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (id != null) 'id': id,
      'title': title,
      if (posterUrl != null) 'posterURL': posterUrl,
      if (imdbId != null) 'imdbId': imdbId,
    };
  }

  MovieModel copyWith({
    int? id,
    String? title,
    String? posterUrl,
    String? imdbId,
  }) {
    return MovieModel(
      id: id ?? this.id,
      title: title ?? this.title,
      posterUrl: posterUrl ?? this.posterUrl,
      imdbId: imdbId ?? this.imdbId,
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
}