import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';

// Widget -> por eso es widget.title
class MovieHorizontalListview extends StatefulWidget {
  // las películas que queremos mostrar
  final List<Movie> movies;
  final String? title;
  final String? subTitle;
  final VoidCallback?
      loadNextPage; // Para saber si llegamos al ifnal del slideshow y cargar las siguientes películas
  // Es opcional porque no sabemos si queremos cargar las siguientes películas

  const MovieHorizontalListview(
      {super.key,
      required this.movies,
      this.title,
      this.subTitle,
      this.loadNextPage});

  @override
  State<MovieHorizontalListview> createState() =>
      _MovieHorizontalListviewState();
}

// State
class _MovieHorizontalListviewState extends State<MovieHorizontalListview> {
  final scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Listener por cada listview, al salir tenemos que dejar de estar escuchando cambios
    scrollController.addListener(
      () {
        if (widget.loadNextPage == null) return;
        // En caso de tener callback -> widget
        if ((scrollController.position.pixels + 200) >=
            scrollController.position.maxScrollExtent) {
          print('Load next movies');
          widget.loadNextPage!();
        }
      },
    );
  }

// cuando se destruye la pantalla
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Column(
        children: [
          if (widget.title != null || widget.subTitle != null)
            _Title(
              title: widget.title,
              subTitle: widget.subTitle,
            ),
          Expanded(
              child: ListView.builder(
            controller: scrollController,
            itemCount: widget.movies.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return FadeInRight(child: _Slide(movie: widget.movies[index]));
            },
          )),
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final Movie movie;
  const _Slide({required this.movie});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Para que quede alineado al inicio
          children: [
            // ** Imagen **
            SizedBox(
                width: 150,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      movie.posterPath,
                      fit: BoxFit.cover,
                      width: 150,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress != null) {
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child:
                                    CircularProgressIndicator(strokeWidth: 2)),
                          );
                        }

                        return FadeIn(child: child);
                      },
                    ))),
            const SizedBox(height: 5),
            // ** Título **
            SizedBox(
              width: 150,
              child:
                  Text(movie.title, maxLines: 2, style: textStyle.titleSmall),
            ),

            // ** Rating **
            SizedBox(
              width: 150,
              child: Row(
                children: [
                  Icon(Icons.star_half_outlined, color: Colors.yellow.shade800),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    '${movie.voteAverage}',
                    style: textStyle.bodyMedium?.copyWith(
                      color: Colors.yellow.shade800,
                    ),
                  ),
                  // SizedBox(width: 10),
                  const Spacer(),
                  // Text('${movie.popularity}', style: textStyle.bodySmall),
                  Text(HumanFormats.number(movie.popularity),
                      style: textStyle.bodySmall),
                  // Text('${movie.popularity}', style: textStyle.bodySmall),
                ],
              ),
            ),
          ],
        ));
  }
}

class _Title extends StatelessWidget {
  final String? title;
  final String? subTitle;
  const _Title({this.title, this.subTitle});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge;
    return Container(
      padding: const EdgeInsets.only(top: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          if (title != null)
            Text(
              title!,
              style: titleStyle,
            ),
          const Spacer(),
          if (subTitle != null)
            FilledButton.tonal(
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
              onPressed: () {},
              child: Text(subTitle!),
            )
        ],
      ),
    );
  }
}
