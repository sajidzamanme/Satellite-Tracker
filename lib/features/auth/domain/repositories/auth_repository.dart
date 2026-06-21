import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:satelite_tracker/core/network/failure.dart';

abstract class AuthRepository {
  Stream<User?> get authStateChanges;
  User? get currentUser;
  Future<Either<Failure, UserCredential>> signInAnonymously();
  Future<Either<Failure, void>> signOut();
}
