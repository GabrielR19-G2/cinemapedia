import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Implementación del provider.
final movieInfoProvider =
    StateNotifierProvider<MovieMapNotifier, Map<String, Movie>>(
  (ref) {
    final movieRepository = ref.watch(movieRepositoryProvider);
    // Solo se está pasando la referencia.
    return MovieMapNotifier(getMovie: movieRepository.getMovieById);
  },
);

/// Clase para que sirva para mantener en caché todas las peliculas que se han consultado.

//esperamos una funcion de regreso. Regresa una pelicula que recibe el movieId
typedef GetMovieCallback = Future<Movie> Function(String movieId);

class MovieMapNotifier extends StateNotifier<Map<String, Movie>> {
  final GetMovieCallback getMovie;
  MovieMapNotifier({required this.getMovie}) : super({});

  /// Llamar la implementacion de la funcion que trae la info de la película.
  Future<void> loadMovie(String movieId) async {
    if (state[movieId] != null) return;
    final movie = await getMovie(movieId);
    //Actualizacion al estado. nuevo estado. Si la movie existe, si no regresa una excepcion
    state = {...state, movieId: movie};
  }
}
