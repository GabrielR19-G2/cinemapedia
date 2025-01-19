// Utilizado solamente para utilizar datos de moviedb
import 'package:dio/dio.dart';

import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';

import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

class MovieDbDatasource extends MoviesDataSource {
  // Cliente peticiones http
  final dio = Dio(BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Environment.theMovieDbKey,
        'language': 'es-MX'
      }));

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response = await dio.get('/movie/now_playing');
    final movieDBResponse =
        MovieDbResponse.fromJson(response.data); //Recibiendo el Json

    final List<Movie> movies = movieDBResponse.results
        // En caso de que no tenga poster -> no va a mostrar la película
        .where((moviedb) => moviedb.posterPath != 'no-poster')
        .map(
          // usando el mapper,
          (moviedb) => MovieMapper.movieDBToEntity(moviedb),
        )
        .toList();
    return movies;
  }
}
