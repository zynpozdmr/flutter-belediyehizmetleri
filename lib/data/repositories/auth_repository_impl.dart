import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/domain/repositories/auth_repository.dart';
import 'package:project/core/errors/auth_exception.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  @override
  Future<UserCredential> login(String email, String password) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'Bu e-posta adresine kayıtlı kullanıcı bulunamadı.';
          break;
        case 'wrong-password':
          errorMessage = 'Yanlış şifre. Lütfen tekrar deneyin.';
          break;
        case 'invalid-email':
          errorMessage = 'Geçersiz e-posta adresi formatı.';
          break;
        case 'user-disabled':
          errorMessage = 'Bu kullanıcı hesabı devre dışı bırakılmıştır.';
          break;
        case 'too-many-requests':
          errorMessage = 'Çok fazla deneme. Lütfen daha sonra tekrar deneyin.';
          break;
        case 'invalid-credential': // hatayı yakalayacak
        case 'auth/invalid-credential': 
          errorMessage = 'E-posta veya şifre yanlış. Lütfen bilgilerinizi kontrol edin.';
          break;
        default:
          errorMessage = e.message ?? 'Giriş yapılamadı. Lütfen bilgilerinizi kontrol edin ve tekrar deneyin.';
      }
      throw AuthException(errorMessage);
    } catch (e) {
      throw AuthException('Beklenmeyen bir hata oluştu: ${e.toString()}');
    }
  }

  @override
  Future<UserCredential> register(String email, String password) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'Şifre çok zayıf. Lütfen en az 6 karakterli güçlü bir şifre seçin.';
          break;
        case 'email-already-in-use':
          errorMessage = 'Bu e-posta adresi zaten kullanımda.';
          break;
        case 'invalid-email':
          errorMessage = 'Geçersiz e-posta adresi formatı.';
          break;
        default:
          errorMessage = e.message ?? 'Kayıt başarısız oldu. Lütfen bilgilerinizi kontrol edin ve tekrar deneyin.';
      }
      throw AuthException(errorMessage);
    } catch (e) {
      throw AuthException('Beklenmeyen bir hata oluştu: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Çıkış yapılırken bir hata oluştu.');
    } catch (e) {
      throw AuthException('Beklenmeyen bir hata oluştu: ${e.toString()}');
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'Bu e-posta adresine kayıtlı kullanıcı bulunamadı.';
          break;
        case 'invalid-email':
          errorMessage = 'Geçersiz e-posta adresi formatı.';
          break;
        default:
          errorMessage = e.message ?? 'Şifre sıfırlama e-postası gönderilemedi.';
      }
      throw AuthException(errorMessage);
    } catch (e) {
      throw AuthException('Beklenmeyen bir hata oluştu: ${e.toString()}');
    }
  }

  @override
  bool get isAuthenticated {
    return _firebaseAuth.currentUser != null;
  }
}
