import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie_model.dart';
import '../services/database_service.dart';

/// Pantalla de Gestión (CrudScreen)
///
/// Permite al usuario Crear, Actualizar y Eliminar sus propias películas.
///
/// Funcionalidades:
/// - Formulario dinámico que sirve tanto para Agregar como para Editar.
/// - Vista previa en tiempo real de la imagen por URL.
/// - Lista inferior con las películas existentes, permitiendo editarlas o borrarlas.
/// - Interactúa directamente con `DatabaseService` para persistir los cambios en Firebase.
class CrudScreen extends StatefulWidget {
  const CrudScreen({super.key});

  @override
  _CrudScreenState createState() => _CrudScreenState();
}

class _CrudScreenState extends State<CrudScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String year = '';
  String director = '';
  String genre = '';
  String synopsis = '';
  String imageUrl = '';
  
  // Variables para modo edición
  bool isEditing = false;
  String? editingMovieId;

  @override
  Widget build(BuildContext context) {
    final dbService = Provider.of<DatabaseService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Películas'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              isEditing ? 'Editar Película' : 'Agregar Película',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Título'),
                    validator: (val) => val!.isEmpty ? 'Ingresa un título' : null,
                    onChanged: (val) => setState(() => title = val),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Año'),
                    validator: (val) => val!.isEmpty ? 'Ingresa el año' : null,
                    onChanged: (val) => setState(() => year = val),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Director'),
                    validator: (val) => val!.isEmpty ? 'Ingresa el director' : null,
                    onChanged: (val) => setState(() => director = val),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Género'),
                    validator: (val) => val!.isEmpty ? 'Ingresa el género' : null,
                    onChanged: (val) => setState(() => genre = val),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Sinopsis'),
                    maxLines: 3,
                    validator: (val) => val!.isEmpty ? 'Ingresa la sinopsis' : null,
                    onChanged: (val) => setState(() => synopsis = val),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'URL de Imagen',
                      hintText: 'https://ejemplo.com/imagen.jpg',
                    ),
                    onChanged: (val) => setState(() => imageUrl = val),
                  ),
                  const SizedBox(height: 10),
                  if (imageUrl.isNotEmpty)
                    Column(
                      children: [
                        const Text('Vista previa:', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            imageUrl,
                            height: 200,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              height: 200,
                              color: Colors.red[100],
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.error, color: Colors.red, size: 50),
                                    SizedBox(height: 10),
                                    Text(
                                      'URL inválida o imagen no disponible',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (isEditing && editingMovieId != null) {
                                // Modo edición: actualizar película
                                await dbService.updateMovie(
                                  editingMovieId!,
                                  MovieModel(
                                    id: editingMovieId,
                                    title: title,
                                    year: year,
                                    director: director,
                                    genre: genre,
                                    synopsis: synopsis,
                                    imageUrl: imageUrl,
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Película Actualizada')));
                              } else {
                                // Modo agregar: crear nueva película
                                await dbService.addMovie(MovieModel(
                                  title: title,
                                  year: year,
                                  director: director,
                                  genre: genre,
                                  synopsis: synopsis,
                                  imageUrl: imageUrl,
                                ));
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Película Agregada')));
                              }
                              
                              // Limpiar formulario
                              _formKey.currentState!.reset();
                              setState(() {
                                title = '';
                                year = '';
                                director = '';
                                genre = '';
                                synopsis = '';
                                imageUrl = '';
                                isEditing = false;
                                editingMovieId = null;
                              });
                            }
                          },
                          child: Text(isEditing ? 'Actualizar Película' : 'Agregar Película'),
                        ),
                      ),
                      if (isEditing) ...[
                        const SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                          onPressed: () {
                            setState(() {
                              _formKey.currentState!.reset();
                              title = '';
                              year = '';
                              director = '';
                              genre = '';
                              synopsis = '';
                              imageUrl = '';
                              isEditing = false;
                              editingMovieId = null;
                            });
                          },
                          child: const Text('Cancelar'),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 40, thickness: 2),
            const Text(
              'Eliminar Películas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 300, // Altura fija para la lista dentro del scroll
              child: StreamBuilder<List<MovieModel>>(
                stream: dbService.movies,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const CircularProgressIndicator();
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final movie = snapshot.data![index];
                      return ListTile(
                        title: Text(movie.title),
                        subtitle: Text('${movie.year} • ${movie.genre}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                // Llenar el formulario con los datos de la película
                                setState(() {
                                  isEditing = true;
                                  editingMovieId = movie.id;
                                  title = movie.title;
                                  year = movie.year;
                                  director = movie.director;
                                  genre = movie.genre;
                                  synopsis = movie.synopsis;
                                  imageUrl = movie.imageUrl;
                                });
                                // Scroll automático hacia arriba
                                Scrollable.ensureVisible(
                                  _formKey.currentContext!,
                                  duration: const Duration(milliseconds: 500),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await dbService.deleteMovie(movie.id!);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
