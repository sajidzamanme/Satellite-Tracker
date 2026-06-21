import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:satelite_tracker/core/network/failure.dart';
import 'package:satelite_tracker/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth;

  AuthRepositoryImpl(this._auth);

  @override
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Future<Either<Failure, UserCredential>> signInAnonymously() {
    return TaskEither<Failure, UserCredential>.tryCatch(
      () => _auth.signInAnonymously(),
      (error, stackTrace) {
        if (error is FirebaseAuthException) {
          return Failure(error.message ?? 'Authentication failed');
        }
        return Failure(error.toString());
      },
    ).run();
  }

  @override
  Future<Either<Failure, void>> signOut() {
    return TaskEither<Failure, void>.tryCatch(
      () => _auth.signOut(),
      (error, stackTrace) {
        if (error is FirebaseAuthException) {
          return Failure(error.message ?? 'Sign out failed');
        }
        return Failure(error.toString());
      },
    ).run();
  }
}
