import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/shared/custom_bottom_navigation_bar.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _HomeView(),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}

class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  // ConsumerState<_HomeView> createState() => _HomeViewStateState();
  _HomeViewStateState createState() => _HomeViewStateState();
}

class _HomeViewStateState extends ConsumerState<_HomeView> {
  @override
  void initState() {
    super.initState();
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final initialLoading = ref.watch(initialLoadingProvider);
    if (initialLoading) return const FullScreenLoader();

    ///Watch -> Pendiente del estado
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    // Usar el nuevo provider ->  moviesSliderProvider
    final slideShowMovies = ref.watch(moviesSliderProvider);
    final popularMovies = ref.watch(popularMoviesProvider);
    final upcomingMovies = ref.watch(upcomingMoviesProvider);
    final topRatedMovies = ref.watch(topRatedMoviesProvider);

    // if (nowPlayingMovies.length == 0)
    //   return const Center(child: CircularProgressIndicator());
    return CustomScrollView(
        // Slivers -> ScrollView -> Widget que trabaja directamente con el scrollView
        slivers: [
          const SliverAppBar(
            // Como un appbar tradicional pero funciona directamente con el scrollview
            floating: true,
            flexibleSpace: FlexibleSpaceBar(title: CustomAppbar()),
          ),
          // Para mostrar contenido, Función para poder crear los widgets
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                // Lo que usaremos para contruir dentro
                return Column(
                  children: [
                    ///Expanded -> dado el padre, expanda todo lo posible (ya tiene ancho y largo fijo)
                    // Expanded(
                    //   child: ListView.builder(
                    //     itemCount: nowPlayingMovies.length,
                    //     itemBuilder: (context, index) {
                    //       final movie = nowPlayingMovies[index];
                    //       return ListTile(title: Text(movie.title));
                    //     },
                    //   ),
                    // )

                    MoviesSlideshow(movies: slideShowMovies),
                    MovieHorizontalListview(
                      movies: nowPlayingMovies,
                      title: 'En cines',
                      subTitle: 'Lunes 20',
                      loadNextPage: () => ref
                          .read(nowPlayingMoviesProvider.notifier)
                          .loadNextPage(),
                    ),
                    MovieHorizontalListview(
                      movies: upcomingMovies,
                      title: 'Próximamente',
                      subTitle: 'Este mes',
                      loadNextPage: () => ref
                          .read(upcomingMoviesProvider.notifier)
                          .loadNextPage(),
                    ),
                    MovieHorizontalListview(
                      movies: popularMovies,
                      title: 'Populares',
                      loadNextPage: () => ref
                          .read(popularMoviesProvider.notifier)
                          .loadNextPage(),
                    ),
                    MovieHorizontalListview(
                      movies: topRatedMovies,
                      title: 'Mejores calificadas',
                      subTitle: 'Desde siempre',
                      loadNextPage: () => ref
                          .read(topRatedMoviesProvider.notifier)
                          .loadNextPage(),
                    ),

                    const SizedBox(height: 10)
                  ],
                );
              },
              childCount: 10,
            ),
          )
        ]);
  }
}
