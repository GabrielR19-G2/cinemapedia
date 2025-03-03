import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/movies_repository.dart';

// implementación del repositorio
// llamar el datasource
/// 3-. aquí se implementa lo del moviedb_datasource
class MovieRepositoryImpl extends MoviesRepository {
  final MoviesDataSource datasource;

  MovieRepositoryImpl({required this.datasource});

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) {
    // Mandar a llamar el datasource
    return datasource.getNowPlaying(page: page);
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) {
    return datasource.getPopular(page: page);
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) {
    return datasource.getTopRated(page: page);
  }

  @override
  Future<List<Movie>> getUpcoming({int page = 1}) {
    return datasource.getUpcoming(page: page);
  }
}
