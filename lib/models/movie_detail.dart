import 'package:the_movie_database/models/movie.dart';

class MovieDetail {
  final String title;
  final String year;
  final String rated;
  final String released;
  final String runtime;
  final String genre;
  final String director;
  final String writer;
  final String actors;
  final String plot;
  final String language;
  final String country;
  final String awards;
  final String poster;
  final String metascore;
  final String imdbRating;
  final String imdbVotes;
  final String imdbID;
  final String type;
  final String boxOffice;

  MovieDetail({
    required this.title,
    required this.year,
    required this.rated,
    required this.released,
    required this.runtime,
    required this.genre,
    required this.director,
    required this.writer,
    required this.actors,
    required this.plot,
    required this.language,
    required this.country,
    required this.awards,
    required this.poster,
    required this.metascore,
    required this.imdbRating,
    required this.imdbVotes,
    required this.imdbID,
    required this.type,
    required this.boxOffice,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
      title: json['Title'] ?? 'Unknown',
      year: json['Year'] ?? 'Unknown',
      rated: json['Rated'] ?? 'N/A',
      released: json['Released'] ?? 'N/A',
      runtime: json['Runtime'] ?? 'N/A',
      genre: json['Genre'] ?? 'N/A',
      director: json['Director'] ?? 'N/A',
      writer: json['Writer'] ?? 'N/A',
      actors: json['Actors'] ?? 'N/A',
      plot: json['Plot'] ?? 'No plot available',
      language: json['Language'] ?? 'N/A',
      country: json['Country'] ?? 'N/A',
      awards: json['Awards'] ?? 'N/A',
      poster: json['Poster'] ?? '',
      metascore: json['Metascore'] ?? 'N/A',
      imdbRating: json['imdbRating'] ?? 'N/A',
      imdbVotes: json['imdbVotes'] ?? 'N/A',
      imdbID: json['imdbID'] ?? '',
      type: json['Type'] ?? '',
      boxOffice: json['BoxOffice'] ?? 'N/A',
    );
  }
}
