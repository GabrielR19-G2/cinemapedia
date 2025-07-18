import 'package:cinemapedia/infrastructure/datasources/actor_moviedb_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/actor_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// #7/8

// La data no cambia, será de solo lectura
// Provider -> Proveedor de información
final actorRepositoryProvider = Provider(
  (ref) {
    return ActorRepositoryImpl(datasource: ActorMoviedbDatasource());
  },
);
