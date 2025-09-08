import 'dart:io' show Platform;
import 'package:firebase_auth/firebase_auth.dart';
import '../data/repos/user_repository.dart';
import '../data/models/user_profile.dart';

class AuthService {
  AuthService._();
  static final instance = AuthService._();

  final _auth = FirebaseAuth.instance;

  Stream<User?> get authState => _auth.authStateChanges();
  User? get user => _auth.currentUser;

  Future<List<String>> fetchProviders(String email) =>
      _auth.fetchSignInMethodsForEmail(email);

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  Future<UserCredential> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await cred.user?.updateDisplayName(name);

    await UserRepository.instance.upsert(
      UserProfile(uid: cred.user!.uid, name: name, email: email),
    );

    return cred;
  }

  Future<void> sendPasswordReset(String email) =>
      _auth.sendPasswordResetEmail(email: email);

  Future<void> signOut() => _auth.signOut();

  Future<UserCredential> signInWithGoogle() async {
    if (Platform.isAndroid || Platform.isIOS) {
      throw UnimplementedError('Adicione google_sign_in p/ mobile');
    } else {
      final provider = GoogleAuthProvider();
      return _auth.signInWithPopup(provider);
    }
  }
}
