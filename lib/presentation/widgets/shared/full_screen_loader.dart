import 'package:cinemapedia/presentation/widgets/widgets.dart';

/// Loader a pantalla completa
class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  Stream<String> getLoadingMessages() {
    final messages = <String>[
      'Cargando películas',
      'Comprando palomitas de maíz',
      'Cargando populares',
      'Llamando a mi pareja',
      'Ya casi...',
      'Esto está tardando más de lo esperado :(',
    ];

    // Pare regresarlo cada x tiempo
    return Stream.periodic(const Duration(milliseconds: 1200), (step) {
      return messages[step];
      // lo cancela cuando llega al límite (largo del arreglo)
    }).take(messages.length);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Espere por favor'),
        const SizedBox(height: 10),
        const CircularProgressIndicator(strokeWidth: 2),
        const SizedBox(height: 10),

        //Construye basado en un string
        StreamBuilder(
          stream: getLoadingMessages(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('Cargando...');
            return Text(snapshot.data!); //En este punto ya tenemos data
          },
        )
      ],
    ));
  }
}
