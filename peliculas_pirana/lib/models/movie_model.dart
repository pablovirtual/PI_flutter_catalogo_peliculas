/// Modelo de datos para representar una película en la aplicación.
/// 
/// Esta clase define la estructura de datos que se utiliza tanto para
/// las películas almacenadas en Firebase como para las obtenidas de TMDB.
/// Incluye métodos de conversión `toMap` y `fromMap` para facilitar
/// la serialización y deserialización de datos.
class MovieModel {
  String? id;
  String title;
  String year;
  String director;
  String genre;
  String synopsis;
  String imageUrl;

  MovieModel({
    this.id,
    required this.title,
    required this.year,
    required this.director,
    required this.genre,
    required this.synopsis,
    required this.imageUrl,
  });

  // Convertir a Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'year': year,
      'director': director,
      'genre': genre,
      'synopsis': synopsis,
      'imageUrl': imageUrl,
    };
  }

  // Crear objeto desde Firestore
  factory MovieModel.fromMap(Map<String, dynamic> map, String documentId) {
    return MovieModel(
      id: documentId,
      title: map['title'] ?? '',
      year: map['year'] ?? '',
      director: map['director'] ?? '',
      genre: map['genre'] ?? '',
      synopsis: map['synopsis'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}
