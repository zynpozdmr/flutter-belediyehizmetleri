import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project/presentation/providers/auth_provider.dart';
import 'package:project/core/constants/app_colors.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void _showSnackBar(BuildContext context, String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.errorRed : AppColors.successGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Şifremi Unuttum'),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Şifrenizi sıfırlamak için kayıtlı e-posta adresinizi girin.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-posta',
                    hintText: 'Kayıtlı e-posta adresinizi giriniz',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                authProvider.isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          FocusScope.of(context).unfocus(); 
                          authProvider.setErrorMessage(null); 

                          if (emailController.text.isEmpty) {
                            _showSnackBar(context, 'Lütfen e-posta adresinizi giriniz.', isError: true);
                            return;
                          }
        
                          try {

                            _showSnackBar(context, 'Şifre sıfırlama e-postası gönderildi. Lütfen e-postanızı kontrol edin.');
                             await Future.delayed(const Duration(seconds: 2)); 
                             if (mounted) Navigator.pop(context); // Giriş sayfasına geri dön

                          } catch (e) {
                             _showSnackBar(context, e.toString(), isError: true);
                          }
                        },
                        child: const Text('Şifre Sıfırla'),
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
              ],
            ),
          );
        },
      ),
    );
  }
}