import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_movie_database/core/network/network_client.dart';
import 'package:the_movie_database/models/movie.dart';
import 'package:the_movie_database/models/movie_detail.dart';

// --- SERVICE ---
class MovieService {
  final NetworkClient _client;

  MovieService(this._client);

  Future<List<Movie>> searchMovies(String query, int page) async {
    final response = await _client.get('', queryParameters: {
      's': query,
      'page': page,
      'type': 'movie',
    });

    if (response.data['Response'] == 'True') {
      final List results = response.data['Search'];
      return results.map((e) => Movie.fromJson(e)).toList();
    } else {
      throw Exception(response.data['Error'] ?? 'Failed to load movies');
    }
  }

  Future<MovieDetail> getMovieDetails(String imdbId) async {
    final response = await _client.get('', queryParameters: {
      'i': imdbId,
      'plot': 'full',
    });

    if (response.data['Response'] == 'True') {
      return MovieDetail.fromJson(response.data);
    } else {
      throw Exception(response.data['Error'] ?? 'Failed to load details');
    }
  }
}


final networkClientProvider = Provider((ref) => NetworkClient());

final movieServiceProvider = Provider((ref) {
  return MovieService(ref.watch(networkClientProvider));
});

class MovieState {
  final List<Movie> movies;
  final bool isLoading;
  final String? error;
  final int page;
  final String query;
  final bool hasMore;

  MovieState({
    required this.movies,
    required this.isLoading,
    this.error,
    required this.page,
    required this.query,
    required this.hasMore,
  });

  MovieState.initial()
      : movies = [],
        isLoading = false,
        error = null,
        page = 1,
        query = '', // Default query can be empty
        hasMore = true;

  MovieState copyWith({
    List<Movie>? movies,
    bool? isLoading,
    String? error,
    int? page,
    String? query,
    bool? hasMore,
  }) {
    return MovieState(
      movies: movies ?? this.movies,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      page: page ?? this.page,
      query: query ?? this.query,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class MovieNotifier extends StateNotifier<MovieState> {
  final MovieService _service;

  MovieNotifier(this._service) : super(MovieState.initial());

  Future<void> search(String query) async {
    if (query.isEmpty) return;
    
    state = MovieState(
      movies: [],
      isLoading: true,
      page: 1,
      query: query,
      hasMore: true,
    );

    try {
      final movies = await _service.searchMovies(query, 1);
      state = MovieState(
        movies: movies,
        isLoading: false,
        page: 1,
        query: query,
        hasMore: movies.length == 10,
      );
    } catch (e) {
      state = MovieState(
        movies: [],
        isLoading: false,
        error: e.toString(),
        page: 1,
        query: query,
        hasMore: false,
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    final nextPage = state.page + 1;
    state = state.copyWith(isLoading: true); // Keep existing movies

    try {
      final newMovies = await _service.searchMovies(state.query, nextPage);
      state = MovieState(
        movies: [...state.movies, ...newMovies],
        isLoading: false,
        page: nextPage,
        query: state.query,
        hasMore: newMovies.length == 10,
      );
    } catch (e) {
      // If error on pagination, maybe show snackbar, but here we just stop loading
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final movieProvider = StateNotifierProvider<MovieNotifier, MovieState>((ref) {
  return MovieNotifier(ref.watch(movieServiceProvider));
});

// Provider for Movie Details (Family)
final movieDetailsProvider = FutureProvider.family<MovieDetail, String>((ref, imdbId) async {
  final service = ref.watch(movieServiceProvider);
  return service.getMovieDetails(imdbId);
});
