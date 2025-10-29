import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = GetIt.instance<AuthRepository>();

  bool _isLoading = false;
  String? _errorMessage;
  User? _currentUser; 

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser; 

  void setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }
  AuthProvider() {
    _authRepository.authStateChanges.listen((User? user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  // Login işlemi
  Future<void> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null; 
    notifyListeners(); 

    try {
      await _authRepository.login(email, password);
    } catch (e) {
      _errorMessage = e.toString(); 
      print("Login failed in AuthProvider: $_errorMessage"); 
    } finally {
      _isLoading = false;
      notifyListeners(); 
    }
  }

  // Logout işlemi
  Future<void> logout() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authRepository.logout();
      _currentUser = null; 
    } catch (e) {
      _errorMessage = e.toString();
      print("Logout failed in AuthProvider: $_errorMessage");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Kayıt işlemi
  Future<void> register(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authRepository.register(email, password);
    } catch (e) {
      _errorMessage = e.toString();
      print("Registration failed in AuthProvider: $_errorMessage");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Şifre sıfırlama işlemi
  Future<void> resetPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authRepository.resetPassword(email); 
    } catch (e) {
      _errorMessage = e.toString();
      print("Password reset failed in AuthProvider: $_errorMessage"); 
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool get isAuthenticated => _currentUser != null;

  void setCurrentUser(User? firebaseUser) {}
}