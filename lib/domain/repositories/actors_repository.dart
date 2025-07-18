import 'package:cinemapedia/domain/entities/actor.dart';

// #2
abstract class ActorsRepository {
  Future<List<Actor>> getActorsByMovie(String movieId);
}
