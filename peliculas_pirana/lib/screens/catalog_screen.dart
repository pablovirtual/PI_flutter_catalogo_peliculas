import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/movie_model.dart';
import '../services/database_service.dart';
import '../services/auth_service.dart';
import '../services/tmdb_service.dart';
import 'crud_screen.dart';
import 'detail_screen.dart';
import 'welcome_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  _CatalogScreenState createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final TMDBService _tmdbService = TMDBService();
  List<MovieModel> _tmdbMovies = [];
  bool _loadingTMDB = true;

  @override
  void initState() {
    super.initState();
    _loadTMDBMovies();
  }

  Future<void> _loadTMDBMovies() async {
    final movies = await _tmdbService.getPopularMovies();
    setState(() {
      _tmdbMovies = movies;
      _loadingTMDB = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dbService = Provider.of<DatabaseService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Películas'),
        backgroundColor: Colors.blueAccent,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(Icons.account_circle, size: 50, color: Colors.white),
                  const SizedBox(height: 10),
                  const Text(
                    'Películas Piraña',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    FirebaseAuth.instance.currentUser?.email ?? 'Usuario',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.video_library),
              title: const Text('Catálogo'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_circle),
              title: const Text('Agregar Películas'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CrudScreen()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.red),
              title: const Text('Cerrar Sesión',
                  style: TextStyle(color: Colors.red)),
              onTap: () async {
                await authService.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WelcomeScreen()),
                  (route) => false,
                ); 
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder<List<MovieModel>>(
        stream: dbService.movies,
        builder: (context, firebaseSnapshot) {
          // Mientras carga TMDB o Firebase
          if (_loadingTMDB || firebaseSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Obtener películas de Firebase
          final firebaseMovies = firebaseSnapshot.data ?? [];
          
          // Combinar: Firebase primero, luego TMDB
          final allMovies = [...firebaseMovies, ..._tmdbMovies];

          if (allMovies.isEmpty) {
            return const Center(
              child: Text('No hay películas disponibles.\nAgrega tu primera película desde el menú.'),
            );
          }

          return ListView.builder(
            itemCount: allMovies.length,
            itemBuilder: (context, index) {
              final movie = allMovies[index];
              final isFromFirebase = index < firebaseMovies.length;
              
              return Card(
                margin: const EdgeInsets.all(10),
                elevation: 4,
                color: isFromFirebase ? Colors.green[50] : null,
                child: ListTile(
                  leading: movie.imageUrl.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            movie.imageUrl,
                            width: 60,
                            height: 90,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.movie, size: 50),
                          ),
                        )
                      : const Icon(Icons.movie, size: 50),
                  title: Text(
                    movie.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${movie.year} • ${movie.genre}'),
                      if (isFromFirebase)
                        const Text(
                          '✨ Tu película',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(movie: movie),
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
