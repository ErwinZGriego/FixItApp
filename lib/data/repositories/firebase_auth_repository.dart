import 'package:cloud_firestore/cloud_firestore.dart'; // <--- 1. Importar Firestore
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/enums/user_role.dart';
import '../../domain/models/app_user.dart';
import '../../domain/repositories/i_auth_repository.dart';

class FirebaseAuthRepository implements IAuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // <--- 2. Instancia DB

  @override
  String? get currentUserId => _auth.currentUser?.uid;

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseError(e.code));
    }
  }

  @override
  Future<void> signUp(String email, String password) async {
    try {
      // 1. Crear usuario en Auth (Authentication)
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user?.uid;
      if (uid == null) return;

      // 2. Crear documento en DB (Firestore) con rol por defecto 'student'
      final newUser = AppUser(
        id: uid,
        email: email,
        role: UserRole.student, // <--- Rol por defecto
      );

      await _firestore.collection('users').doc(uid).set(newUser.toMap());
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseError(e.code));
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // --- Método extra para obtener el rol del usuario actual ---
  // (Tendremos que agregarlo a la interfaz IAuthRepository también)
  @override
  Future<UserRole> getUserRole() async {
    final uid = currentUserId;
    if (uid == null) return UserRole.student; // Fallback seguro

    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) return UserRole.student;

      final data = doc.data()!;
      // Usamos el fromMap de nuestro modelo para sacar el rol
      return AppUser.fromMap(data).role;
    } catch (e) {
      return UserRole.student;
    }
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No existe usuario con ese correo.';
      case 'wrong-password':
        return 'Contraseña incorrecta.';
      case 'email-already-in-use':
        return 'Este correo ya está registrado.';
      case 'invalid-email':
        return 'El formato del correo es inválido.';
      case 'weak-password':
        return 'La contraseña es muy débil.';
      default:
        return 'Error de autenticación: $code';
    }
  }
}
