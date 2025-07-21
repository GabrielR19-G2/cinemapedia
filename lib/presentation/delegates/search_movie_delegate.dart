import 'dart:async';

import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

// Funcion que tiene que cumplir con esta firma
typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMoviesCallback searchMovies;

  // Solo se suscribe una vez. StreamController.
  // Multiples listeners.
  StreamController<List<Movie>> debounceMovies = StreamController.broadcast();
  // setTimeout.
  Timer? _debounceTimer;
  final List<Movie> initialMovies;

  SearchMovieDelegate({required this.searchMovies, required this.initialMovies})
      : super(
          searchFieldLabel: 'Buscar películas',
        );

  void clearStreams() {
    debounceMovies.close();
  }

  /// Cada que se toque una tecla, se va a mandar a llamar.
  void _onQueryChanged(String query) {
    //
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    print('query String cambio');
    // Cuando deja de escribir por 500 milesimas de segundo, va a buscar la película.
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      // TODO: Buscar película y emitir al stream.
      // Si la query esta vacía, se regresa una lista vacía de películas.
      // if (query.isEmpty) {
      //   debounceMovies.add([]);
      //   return; // Para no hacer un else.
      // }
      //TODO: Si el query esta vacio, las peliculas seran arreglo vacio.
      final movie = await searchMovies(query);
      debounceMovies.add(movie);
    });
  }

  @override
  String get searchFieldLabel => 'Buscar película';

  // Acciones de arriba
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      FadeInRight(
          animate: query.isNotEmpty,
          duration: const Duration(milliseconds: 200),
          child: IconButton(
              onPressed: () => query = '', icon: const Icon(Icons.clear)))
    ];
  }

  // Para construir un ico no o algo en la parte del leading/inicio
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        // null -> suponemos que no hizo nada en la busqueda.
        onPressed: () {
          clearStreams();
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back_ios_new_outlined));
  }

  //Lo que se va a mostrar cuando la persona de 'enter'
  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder(
      //Esto va a crear otro stream (al presionar 'enter')
      stream: debounceMovies.stream,
      builder: (context, snapshot) {
        // final previousMovies = debounceMovies.stream.last; //Esto solo recupera la última película

        final movies = snapshot.data ?? [];
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) => _MovieItem(
            movie: movies[index],
            onMovieSelected: (context, movie) {
              close(context, movie);
              clearStreams();
            },
          ),
        );
      },
    );
  }

  //Cuando la persona esta escribiendo, que es lo que queremos hacer.
  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);

    // Se dispara/manda a llamar cuando se está escribiendo (se muestra hasta antes de dar 'enter')
    // Cuando estamos en un build. Tecnicamaente podríamos usar un gestor de estado para construir esto de manera automática.
    //
    return StreamBuilder(
      stream: debounceMovies.stream,
      initialData: initialMovies,
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) => _MovieItem(
            movie: movies[index],
            onMovieSelected: (context, movie) {
              close(context, movie);
              clearStreams();
            },
          ),
          // itemBuilder: (context, index) {
          //   final movie = movies[index];
          //   return ListTile(title: Text(movie.title));
          // },
        );
      },
    );
  }
}

// Para mostrar la película
class _MovieItem extends StatelessWidget {
  final Movie movie;
  final Function onMovieSelected;

  const _MovieItem({required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        onMovieSelected(context, movie);
      },
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              // Image
              SizedBox(
                  width: size.width * 0.2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      movie.posterPath,
                      loadingBuilder: (context, child, loadingProgress) =>
                          FadeIn(child: child),
                    ),
                  )),

              const SizedBox(width: 10),
              // Description
              SizedBox(
                  width: size.width * 0.7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(movie.title, style: textStyles.titleMedium),
                      movie.overview.length > 100
                          ? Text(movie.overview.substring(0, 100),
                              style: textStyles.titleMedium)
                          : Text(movie.overview),
                      Row(
                        children: [
                          Icon(Icons.star_half_outlined,
                              color: Colors.yellow.shade800),
                          const SizedBox(width: 5),
                          Text(
                            HumanFormats.number(movie.voteAverage, 1),
                            style: textStyles.bodySmall!
                                .copyWith(color: Colors.yellow.shade900),
                          )
                        ],
                      ),
                    ],
                  )),
            ],
          )),
    );
  }
}
