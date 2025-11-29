import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie_model.dart';

class TMDBService {
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String _bearerToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlOWQxYTZlYTYxZDU4MWQ2MzJkNTk0OTY4MmU4NWZkYyIsIm5iZiI6MTc2NDQzOTMyMS4xMzYsInN1YiI6IjY5MmIzNTE5NTQwZjcxZjQ0ZWRmNzVmNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.qkyZagyA0YiwZiLuR8jfTGduwhdeSi0ukiy1hZg1GO0';
  static const String _imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  // Obtener películas populares
  Future<List<MovieModel>> getPopularMovies() async {
    final url = Uri.parse('$_baseUrl/movie/popular?language=es-MX&page=1');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_bearerToken',
          'accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List results = data['results'];

        // Convertir las primeras 20 películas
        return results.take(20).map((movieJson) {
          return MovieModel(
            id: movieJson['id'].toString(),
            title: movieJson['title'] ?? 'Sin título',
            year: movieJson['release_date']?.substring(0, 4) ?? 'Desconocido',
            director: 'N/A', // TMDB no incluye director en popular
            genre: _getGenres(movieJson['genre_ids']),
            synopsis: movieJson['overview'] ?? 'Sin sinopsis disponible',
            imageUrl: movieJson['poster_path'] != null
                ? '$_imageBaseUrl${movieJson['poster_path']}'
                : '',
          );
        }).toList();
      } else {
        print('Error TMDB: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error al obtener películas de TMDB: $e');
      return [];
    }
  }

  // Mapeo simple de IDs de género a nombres
  String _getGenres(List<dynamic>? genreIds) {
    if (genreIds == null || genreIds.isEmpty) return 'General';
    
    final Map<int, String> genreMap = {
      28: 'Acción',
      12: 'Aventura',
      16: 'Animación',
      35: 'Comedia',
      80: 'Crimen',
      99: 'Documental',
      18: 'Drama',
      10751: 'Familia',
      14: 'Fantasía',
      36: 'Historia',
      27: 'Terror',
      10402: 'Música',
      9648: 'Misterio',
      10749: 'Romance',
      878: 'Ciencia Ficción',
      10770: 'Película de TV',
      53: 'Suspenso',
      10752: 'Bélica',
      37: 'Western',
    };

    return genreMap[genreIds[0]] ?? 'General';
  }
}
