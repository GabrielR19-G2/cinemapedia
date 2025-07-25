// #6
import 'package:cinemapedia/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/repositories/actors_repository.dart';

class ActorRepositoryImpl extends ActorsRepository {
  // Para mantenerlo general (por eso no se utilizó el actor_moviedb_datasource.dart)
  final ActorsDatasource datasource;

  ActorRepositoryImpl({required this.datasource});
  @override
  Future<List<Actor>> getActorsByMovie(String movieId) {
    return datasource.getActorsByMovie(movieId);
  }
}
