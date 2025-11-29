import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/movie_model.dart';

/// Servicio de Base de Datos (DatabaseService)
///
/// Gestiona la interacción con Cloud Firestore.
/// Permite realizar operaciones CRUD (Crear, Leer, Actualizar, Eliminar)
/// sobre la colección 'movies'.
///
/// Funcionalidades principales:
/// - `addMovie`: Guarda una nueva película en Firestore.
/// - `movies`: Stream que devuelve la lista de películas en tiempo real.
/// - `updateMovie`: Modifica los datos de una película existente.
/// - `deleteMovie`: Elimina una película de la base de datos.
class DatabaseService {
  final CollectionReference movieCollection =
      FirebaseFirestore.instance.collection('movies');

  // Agregar película
  Future<void> addMovie(MovieModel movie) async {
    return await movieCollection.add(movie.toMap()).then((value) => print("Película agregada")).catchError((error) => print("Fallo al agregar película: $error"));
  }

  // Obtener lista de películas (Stream)
  Stream<List<MovieModel>> get movies {
    return movieCollection.snapshots().map(_movieListFromSnapshot);
  }

  // Convertir snapshot a lista de modelos
  List<MovieModel> _movieListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return MovieModel.fromMap(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );
    }).toList();
  }

  // Eliminar película
  Future<void> deleteMovie(String id) async {
    return await movieCollection.doc(id).delete();
  }

  // Actualizar película
  Future<void> updateMovie(String id, MovieModel movie) async {
    return await movieCollection.doc(id).update(movie.toMap());
  }
}
