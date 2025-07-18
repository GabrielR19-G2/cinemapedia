import 'package:cinemapedia/domain/entities/actor.dart';

// #1
abstract class ActorsDatasource {
  ///Definiendo reglas para trabajar el datasource

  Future<List<Actor>> getActorsByMovie(String movieId);
}
