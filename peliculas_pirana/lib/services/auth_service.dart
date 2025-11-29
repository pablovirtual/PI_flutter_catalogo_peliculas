import 'package:firebase_auth/firebase_auth.dart';

/// Servicio de Autenticación (AuthService)
///
/// Gestiona todas las operaciones relacionadas con Firebase Authentication.
/// Proporciona métodos para:
/// - Registrar nuevos usuarios con email y contraseña.
/// - Iniciar sesión (Login).
/// - Cerrar sesión (Logout).
/// - Escuchar cambios en el estado de autenticación (Stream<User?>).
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream para cambios en el estado de autenticación
  Stream<User?> get user => _auth.authStateChanges();

  // Registro con email y contraseña
  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Inicio de sesión con email y contraseña
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
