import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project/presentation/providers/auth_provider.dart';
import 'package:project/core/constants/app_colors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>{
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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

  void _showSuccessSnackBar(BuildContext context, String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.successGreen, 
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kayıt Ol'),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Lütfen email adresinizi giriniz',
                    border: OutlineInputBorder()
                    ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Şifre',
                    hintText: 'Lütfen şifrenizi giriniz',
                    border: OutlineInputBorder(),
                    ),
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Şifre Tekrar',
                    hintText: 'Lütfen şifrenizi tekrar giriniz',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                authProvider.isLoading  
                    ? const CircularProgressIndicator()
                    : ElevatedButton(   
                        onPressed: () async {
                          FocusScope.of(context).unfocus(); 
                          authProvider.setErrorMessage(null);
                          
                          if (passwordController.text != confirmPasswordController.text) {
                            _showErrorSnackBar(context, 'Şifreler uyuşmuyor.');
                            return;  
                          }

                          await authProvider.register(
                            emailController.text,
                            passwordController.text,
                          );

                          if (authProvider.errorMessage == null) {
                            _showSuccessSnackBar(context, 'Kayıt başarılı! Giriş sayfasına yönlendiriliyorsunuz.');
                            Navigator.pushReplacementNamed(context, '/login');
                          }
                        },
                        child: const Text('Kayıt Ol'),
                      ),
                if (authProvider.errorMessage != null && !authProvider.isLoading) 
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      authProvider.errorMessage!, 
                      style: const TextStyle(color: AppColors.errorRed, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                TextButton(
                  onPressed: () {
                    authProvider.setErrorMessage(null); 
                    Navigator.pop(context); 
                  },
                  child: const Text('Zaten hesabım var, Giriş Yap',
                  style: TextStyle(color: AppColors.textDark), 
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