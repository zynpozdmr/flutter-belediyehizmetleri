import 'package:flutter/material.dart';
import 'package:project/core/constants/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:project/presentation/providers/auth_provider.dart';
import 'package:project/presentation/pages/main_page.dart'; 

class LoginPage extends StatefulWidget {
  const LoginPage({super.key}); 

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.successGreen, 
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.errorRed, 
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giriş Yap'),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          
          if (authProvider.errorMessage != null && !authProvider.isLoading) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              _showErrorSnackBar(context, authProvider.errorMessage!);
              
            });
          }

          
          if (authProvider.isAuthenticated) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainPage()),
              );
            });
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: emailController, 
                  keyboardType: TextInputType.emailAddress, 
                  decoration: const InputDecoration(
                    labelText: 'E-posta',
                    hintText: 'E-posta adresinizi giriniz',
                    border: OutlineInputBorder(), 
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: passwordController, 
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Şifre',
                    hintText: 'Şifrenizi giriniz',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10.0),
                Align( 
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                       if (!mounted) return; 
                      Navigator.pushNamed(context, '/forgot_password');
                    },
                    child: const Text(
                      'Şifremi Unuttum',
                      style: TextStyle(color: AppColors.textDark), 
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                authProvider.isLoading
                    ? const CircularProgressIndicator() 
                    : ElevatedButton(
                        onPressed: () async {
                          FocusScope.of(context).unfocus(); 
                          authProvider.setErrorMessage(null);
                          
                          await authProvider.login(
                            emailController.text,
                            passwordController.text,
                          );

                          if (authProvider.errorMessage == null) {
                            _showSuccessSnackBar(context, 'Giriş başarılı!');
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const MainPage()),
                            );
                          }
                          
                        },
                        child: const Text('Giriş Yap'),
                      ),
                const SizedBox(height: 10),
                TextButton( 
                  onPressed: () {
                    authProvider.setErrorMessage(null);
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text(
                    'Kayıt Ol',
                    style: TextStyle(color: AppColors.textDark), 
                  ),
                ),
                
                if (authProvider.errorMessage != null && !authProvider.isLoading)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      authProvider.errorMessage!,
                      style: const TextStyle(color: AppColors.errorRed),
                      textAlign: TextAlign.center,
                    ),
                  ),
                
            
              ],
            ),
          );
        },
      ),
    );
  }
}