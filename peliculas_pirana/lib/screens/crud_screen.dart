import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie_model.dart';
import '../services/database_service.dart';

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
            const Text(
              'Agregar Película',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    decoration: const InputDecoration(labelText: 'URL de Imagen'),
                    onChanged: (val) => setState(() => imageUrl = val),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
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
                        _formKey.currentState!.reset();
                      }
                    },
                    child: const Text('Agregar Película'),
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
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await dbService.deleteMovie(movie.id!);
                          },
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
