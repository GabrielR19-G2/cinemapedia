import 'package:cinemapedia/domain/entities/movie.dart';

// clase abstracta -> No queremos crear instancias de la clase
// Origen de dato
abstract class MoviesDataSource {
  //
  //definición más no implementación
  Future<List<Movie>> getNowPlaying({int page = 1});

  Future<List<Movie>> getPopular({int page = 1});
  Future<List<Movie>> getUpcoming({int page = 1});
  Future<List<Movie>> getTopRated({int page = 1});
}
