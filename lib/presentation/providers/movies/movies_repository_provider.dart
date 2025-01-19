import 'package:cinemapedia/infrastructure/datasources/moviedb_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/infrastructure/repositories/movie_repository_impl.dart';
// Creando instancia del repositorio

// La data no cambia, será de solo lectura
// Provider -> Proveedor de información
final movieRepositoryProvider = Provider(
  (ref) {
    // Origen de datos
    // En caso de cambiar la fuente de información, solo cambiaría lo de MovieDbDatasource()
    return MovieRepositoryImpl(datasource: MovieDbDatasource());
  },
);
