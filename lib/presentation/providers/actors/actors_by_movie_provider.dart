// #7/8

import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/*
Esto es lo que queremos manejar como nuestro estado
 {
  '505642' : <Actor>[]
  '505643' : <Actor>[]
  '505645' : <Actor>[]
  '505641' : <Actor>[]
  } 
 */
// Implementación del provider.
final actorsByMovieProvider =
    StateNotifierProvider<ActorsByMovieNotifier, Map<String, List<Actor>>>(
  (ref) {
    final actorsRepository = ref.watch(actorRepositoryProvider);
    return ActorsByMovieNotifier(getActors: actorsRepository.getActorsByMovie);
  },
);
typedef GetActorsCallback = Future<List<Actor>> Function(String movieId);

class ActorsByMovieNotifier extends StateNotifier<Map<String, List<Actor>>> {
  final GetActorsCallback getActors;
  ActorsByMovieNotifier({required this.getActors}) : super({});

  /// Llamar la implementacion de la funcion que trae la info de la película.
  Future<void> loadActors(String movieId) async {
    if (state[movieId] != null) return;
    final List<Actor> actors = await getActors(movieId);
    //Actualizacion al estado. nuevo estado. Si la movie existe, si no regresa una excepcion
    state = {...state, movieId: actors};
  }
}
