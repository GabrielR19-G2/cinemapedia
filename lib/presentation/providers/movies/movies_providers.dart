// NowPlaying, top rated movie provider...
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

/// Cuando queramos saber cuáles son las películas actuales.
// Proveedor de información que notifica cuando cambia el estado
final nowPlayingMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>(
  (ref) {
    final fetchMoreMovies = ref.watch(movieRepositoryProvider).getNowPlaying;
    return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
  },
);
final popularMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>(
  (ref) {
    final fetchMoreMovies = ref.watch(movieRepositoryProvider).getPopular;
    return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
  },
);

// TODO: upcomingMoviesProvider
final upcomingMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>(
  (ref) {
    final fetchMoreMovies = ref.watch(movieRepositoryProvider).getUpcoming;
    return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
  },
);
// TODO: topRatedMoviesProvider
final topRatedMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>(
  (ref) {
    final fetchMoreMovies = ref.watch(movieRepositoryProvider).getTopRated;
    return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
  },
);

/// Especifica el tipo de función que esperamos
typedef MovieCallback = Future<List<Movie>> Function({int page});

// De manera general, para que sirva para otros providers
class MoviesNotifier extends StateNotifier<List<Movie>> {
  int currentPage = 0;
  bool isLoading = false;
  MovieCallback fetchMoreMovies;
  MoviesNotifier({required this.fetchMoreMovies}) : super([]);

  /// Hacer alguna modificación al state.
  Future<void> loadNextPage() async {
    if (isLoading) return;
    isLoading = true; // Para impedir nuevas peticiones (4ta, 5ta vez...)
    currentPage++;

    /// Creando un nuevo valor para que stateNotifier sea notificado.
    final List<Movie> movies = await fetchMoreMovies(page: currentPage);

    //Regresando un nuevo state
    state = [...state, ...movies];
    await Future.delayed(const Duration(milliseconds: 300));
    isLoading = false;
  }
}
