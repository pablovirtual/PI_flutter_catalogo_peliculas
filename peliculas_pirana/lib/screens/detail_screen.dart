import 'package:flutter/material.dart';
import '../models/movie_model.dart';

/// Pantalla de Detalles (DetailScreen)
///
/// Muestra la información completa de una película seleccionada.
/// Recibe un objeto `MovieModel` como parámetro.
///
/// Visualiza:
/// - Póster de la película en gran tamaño.
/// - Título, Año, Director y Género.
/// - Sinopsis completa.
class DetailScreen extends StatelessWidget {
  final MovieModel movie;

  const DetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen de la película
            if (movie.imageUrl.isNotEmpty)
              Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(movie.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              Container(
                width: double.infinity,
                height: 300,
                color: Colors.grey[300],
                child: const Icon(Icons.movie, size: 100, color: Colors.grey),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  Text(
                    movie.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Año y Director
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 18),
                      const SizedBox(width: 5),
                      Text(
                        movie.year,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 20),
                      const Icon(Icons.person, size: 18),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          movie.director,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Género
                  Row(
                    children: [
                      const Icon(Icons.category, size: 18),
                      const SizedBox(width: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          movie.genre,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 10),
                  // Sinopsis
                  const Text(
                    'Sinopsis',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    movie.synopsis,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
