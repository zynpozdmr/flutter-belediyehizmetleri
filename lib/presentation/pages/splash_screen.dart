import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project/presentation/providers/auth_provider.dart';
import 'package:project/presentation/pages/main_page.dart';
import 'package:project/presentation/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthStatus(); 
    });
  }

  Future<void> _checkAuthStatus() async { 
    await Future.delayed(const Duration(seconds: 2)); 
    User? firebaseUser = FirebaseAuth.instance.currentUser; 
    if (!mounted) return; 
    final authProvider = Provider.of<AuthProvider>(context, listen: false); 
    authProvider.setCurrentUser(firebaseUser);
    if (authProvider.isAuthenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Belediye Hizmetleri Sistemine Hoş Geldiniz',
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
