import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie_model.dart';
import '../services/database_service.dart';
import 'crud_screen.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dbService = Provider.of<DatabaseService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Películas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CrudScreen()),
              );
            },
          )
        ],
      ),
      body: StreamBuilder<List<MovieModel>>(
        stream: dbService.movies,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar películas'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final movies = snapshot.data ?? [];
          // Requerimiento: solo visualizar 5 películas
          final displayMovies = movies.take(5).toList();

          if (displayMovies.isEmpty) {
            return const Center(child: Text('No hay películas disponibles'));
          }

          return ListView.builder(
            itemCount: displayMovies.length,
            itemBuilder: (context, index) {
              final movie = displayMovies[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: movie.imageUrl.isNotEmpty
                      ? Image.network(
                          movie.imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.movie),
                        )
                      : const Icon(Icons.movie),
                  title: Text(movie.title),
                  subtitle: Text('${movie.year} - ${movie.director}'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(movie.title),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (movie.imageUrl.isNotEmpty)
                              Image.network(movie.imageUrl),
                            const SizedBox(height: 10),
                            Text('Año: ${movie.year}'),
                            Text('Director: ${movie.director}'),
                            Text('Género: ${movie.genre}'),
                            const SizedBox(height: 10),
                            Text('Sinopsis:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(movie.synopsis),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cerrar'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
