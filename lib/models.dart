class Viewer {
  Viewer({required this.name, required this.genres, required this.maxMinutes});
  String name;
  Set<String> genres;
  int maxMinutes;
  Map<String, dynamic> toJson() => {
    'name': name,
    'genres': genres.toList(),
    'maxMinutes': maxMinutes,
  };
  factory Viewer.fromJson(Map<String, dynamic> json) => Viewer(
    name: json['name'] as String,
    genres: Set<String>.from(json['genres'] as List),
    maxMinutes: json['maxMinutes'] as int,
  );
}

class Movie {
  const Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.minutes,
    required this.genres,
    required this.description,
    required this.symbol,
    required this.colorValue,
  });
  final String id, title, description, symbol;
  final int year, minutes, colorValue;
  final List<String> genres;
}

class MovieMatch {
  const MovieMatch({
    required this.movie,
    required this.scores,
    required this.groupScore,
    required this.fitsEveryone,
  });
  final Movie movie;
  final List<int> scores;
  final int groupScore;
  final bool fitsEveryone;
}
