import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'catalog_screen.dart';

/// Pantalla de Autenticación (LoginScreen)
///
/// Maneja tanto el Inicio de Sesión como el Registro de nuevos usuarios.
/// Utiliza un formulario con validación para email y contraseña.
///
/// Características:
/// - Alterna dinámicamente entre modo "Login" y "Registro".
/// - Valida formato de email y longitud de contraseña.
/// - Se comunica con `AuthService` para realizar la autenticación.
/// - Redirige al Catálogo en caso de éxito o muestra errores en caso de fallo.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? 'Iniciar Sesión' : 'Registrarse'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Email',
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.pink, width: 2.0),
                  ),
                ),
                validator: (val) => val!.isEmpty ? 'Ingresa un email' : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Contraseña',
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.pink, width: 2.0),
                  ),
                ),
                obscureText: true,
                validator: (val) =>
                    val!.length < 6 ? 'La contraseña debe tener +6 caracteres' : null,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink[400],
                ),
                child: Text(
                  isLogin ? 'Entrar' : 'Registrar',
                  style: const TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    dynamic result;
                    if (isLogin) {
                      result = await authService.signInWithEmailAndPassword(
                          email, password);
                    } else {
                      result = await authService.registerWithEmailAndPassword(
                          email, password);
                    }

                    if (result == null) {
                      setState(() => error = 'Error en credenciales o registro');
                    } else {
                      // Si fue registro, mostrar mensaje de éxito
                      if (!isLogin) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('¡Cuenta creada exitosamente! Bienvenido.'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        // Pequeña espera para que el usuario vea el mensaje
                        await Future.delayed(const Duration(milliseconds: 1500));
                      }

                      // Navegar al catálogo si es exitoso
                      if (mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const CatalogScreen()),
                        );
                      }
                    }
                  }
                },
              ),
              const SizedBox(height: 12.0),
              Text(
                error,
                style: const TextStyle(color: Colors.red, fontSize: 14.0),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    isLogin = !isLogin;
                    error = '';
                  });
                },
                child: Text(isLogin
                    ? '¿No tienes cuenta? Regístrate'
                    : '¿Ya tienes cuenta? Inicia sesión'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
