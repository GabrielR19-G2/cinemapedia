import 'package:go_router/go_router.dart';
import 'package:cinemapedia/presentation/screens/screens.dart';

/// Solo se utiliza para navegación
final appRouter = GoRouter(initialLocation: '', routes: [
  GoRoute(
      path: '/',
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen(),
      // rutas hijas de esta hija
      routes: [
        GoRoute(
          path: 'movie/:id', //Siempre va a ser string
          name: MovieScreen.name,
          builder: (context, state) {
            final movieId = state.pathParameters['id'] ?? 'no-id';
            return MovieScreen(movieId: movieId);
          },
        ),
      ]),
]);
