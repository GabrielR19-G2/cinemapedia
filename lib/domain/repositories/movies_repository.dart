import 'package:cinemapedia/domain/entities/movie.dart';

// De dódne llamamos la información
abstract class MoviesRepository {
  /// 1-. Aquí se define
  //definición más no implementación
  Future<List<Movie>> getNowPlaying({int page = 1});
  Future<List<Movie>> getPopular({int page = 1});

  Future<List<Movie>> getUpcoming({int page = 1});
  Future<List<Movie>> getTopRated({int page = 1});
}
