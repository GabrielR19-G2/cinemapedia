import 'package:cinemapedia/domain/entities/movie.dart';

// De dódne llamamos la información
abstract class MoviesRepository {
  //
  //definición más no implementación
  Future<List<Movie>> getNowPlaying({int page = 1});
}
