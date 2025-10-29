import '../../domain/repositories/auth_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class AuthRepository {
  Future<UserCredential> login(String email, String password);
  Future<UserCredential> register(String email, String password);
  Future<void> logout();
  bool get isAuthenticated; 
  Stream<User?> get authStateChanges;
  Future<void> resetPassword(String email);
}
