import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/movie_model.dart';

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
}
