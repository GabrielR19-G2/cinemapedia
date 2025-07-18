// 3ros
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
// Nuestras implementaciones
import 'package:cinemapedia/domain/entities/movie.dart';

import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/providers/movies/movie_info_provider.dart';

// #9
class MovieScreen extends ConsumerStatefulWidget {
  static const name = 'movie-screen';

  final String movieId;

  const MovieScreen({super.key, required this.movieId});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();
    // En initStatem, metodos, callbacks, ontap, onLongTap es read porque no se puede redibujar
    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId);
  }

  // widgets no son los que llaman las implmenetaciones. widgets llaman providers. providers llaman implementaciones porque todo lo tenemos centralizado.
  @override
  Widget build(BuildContext context) {
    // Información que maneja el mapa.
    //Tenemos un mapa y ahí buscamos la película con el id correspondiente.
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];

    if (movie == null) {
      const Scaffold(
          body: Center(child: CircularProgressIndicator(strokeWidth: 2.0)));
    }
    return movie == null
        ? Scaffold(
            body: Center(child: CircularProgressIndicator(strokeWidth: 2.0)))
        : Scaffold(
            body: CustomScrollView(
            physics:
                const ClampingScrollPhysics(), //Evita la elasticidad (iOS) o rebote.
            slivers: [
              _CustomSliverAppBar(movie: movie),
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (context, index) => _MovieDetails(movie: movie),
                      childCount: 1))
            ],
          ));
  }
}

class _MovieDetails extends StatelessWidget {
  final Movie? movie;
  const _MovieDetails({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    movie!.posterPath,
                    width: size.width * 0.3,
                  )),

              const SizedBox(width: 10),

              // Descripción
              SizedBox(
                width: (size.width - 40) * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(movie?.title ?? '', style: textStyles.titleLarge),
                    Text(movie?.overview ?? ''),
                  ],
                ),
              )
            ],
          ),
        ),
        // Generos de la película
        Padding(
          padding: const EdgeInsets.all(8),
          child: Wrap(
            children: [
              ...movie?.genreIds.map(
                    (genre) => Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: Chip(
                        label: Text(genre),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ) ??
                  []
            ],
          ),
        ),
        // TODO: Mostrar actores ListView
        _ActorsByMovie(movieId: (movie?.id ?? 0).toString()),

        const SizedBox(height: 50),
      ],
    );
  }
}

class _ActorsByMovie extends ConsumerWidget {
  final String movieId;
  const _ActorsByMovie({required this.movieId});

  @override
  Widget build(BuildContext context, ref) {
    // final actorsByMovie = ref.watch(actorsByMovieProvider)[movieId];
    final actorsByMovie = ref.watch(actorsByMovieProvider);

    if (actorsByMovie[movieId] == null) {
      return const CircularProgressIndicator(strokeWidth: 2);
    }
    final actors = actorsByMovie[movieId]!;
    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        itemBuilder: (context, index) {
          final actor = actors[index];
          return Container(
              padding: const EdgeInsets.all(8.0),
              width: 135,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Actor photo
                  FadeInRight(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        actor.profilePath,
                        height: 180,
                        width: 135,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Nombre
                  const SizedBox(height: 5),
                  Text(
                    actor.name,
                    maxLines: 2,
                  ),
                  Text(actor.character ?? '',
                      maxLines: 2,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis)),
                ],
              ));
        },
      ),
    );
  }
}

class _CustomSliverAppBar extends StatelessWidget {
  final Movie? movie;
  const _CustomSliverAppBar({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Appbar personalizado
    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7, //70% de la pantalla
      foregroundColor: Colors.white,
      // shadowColor: Colors.red,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        // title: Text(
        //   movie?.title ?? '',
        //   style: const TextStyle(fontSize: 20, color: Colors.white),
        //   textAlign: TextAlign.start,
        // ),
        background: Stack(
          children: [
            SizedBox.expand(
                child: Image.network(
              movie?.posterPath ?? '',
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress != null) return const SizedBox();

                //Regresando la imagen
                return FadeIn(child: child);
              },
            )),
            // gradientes
            const SizedBox.expand(
                child: DecoratedBox(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [
                  0.7,
                  1.0
                ],
                            colors: [
                  Colors.transparent,
                  Colors.black87
                ])))), //.expand para que tome todo el espacio posible

            const SizedBox.expand(
                child: DecoratedBox(
                    decoration: BoxDecoration(
                        gradient:
                            LinearGradient(begin: Alignment.topLeft, stops: [
              0.0,
              0.3
            ], colors: [
              Colors.black87,
              Colors.transparent,
            ])))) //.expand para que tome todo el espacio posible
          ],
        ),
      ), //Espacio flexible de nuestro appbar
    );
  }
}
