import 'package:flutter/material.dart';
import 'package:project/presentation/pages/splash_screen.dart';
import 'package:project/presentation/pages/login_page.dart';
import 'package:project/presentation/pages/register_page.dart'; 
import 'package:project/presentation/pages/main_page.dart'; 
import 'package:project/presentation/pages/forgot_password_page.dart'; 
import 'package:project/presentation/providers/auth_provider.dart';
import 'package:project/presentation/providers/service_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:project/data/repositories/auth_repository_impl.dart';
import 'package:project/domain/repositories/auth_repository.dart';
import 'package:project/data/repositories/service_repository_impl.dart';
import 'package:project/domain/repositories/service_repository.dart';
import 'package:project/data/services/location_service_impl.dart';
import 'package:project/domain/services/location_service.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project/firebase_options.dart';
import 'package:project/core/constants/app_colors.dart';
import 'package:project/core/constants/app_text_styles.dart';

final getIt = GetIt.instance;

void setupLocator() {
  // Repositories
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  getIt.registerLazySingleton<ServiceRepository>(() => ServiceRepositoryImpl()); 

  // Services 
  getIt.registerLazySingleton<LocationService>(() => LocationServiceImpl());

  // Providers 
  getIt.registerFactory<AuthProvider>(() => AuthProvider());
  getIt.registerFactory<ServiceProvider>(() => ServiceProvider()); 
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupLocator(); 
  runApp(
    const MyApp(),
  );
}

  

class MyApp extends StatelessWidget {
  const MyApp({super.key});

 
  @override
  Widget build(BuildContext context) {
    return MultiProvider( 
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<AuthProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<ServiceProvider>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Belediye Hizmetleri',
        theme: ThemeData(
          primaryColor: AppColors.primaryDarkGrey, 
          scaffoldBackgroundColor: AppColors.backgroundLight, 
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primaryDarkGrey, 
            foregroundColor: AppColors.white, 
            titleTextStyle: AppTextStyles.headlineMedium, 
          ),
          textTheme: TextTheme(
            headlineLarge: AppTextStyles.headlineLarge,
            headlineMedium: AppTextStyles.headlineMedium,
            bodyLarge: AppTextStyles.bodyLarge,
            bodyMedium: AppTextStyles.bodyMedium,
          ).apply(
            fontFamily: 'Poppins', 
            bodyColor: AppColors.textPrimary, 
            displayColor: AppColors.textPrimary, 
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryDarkGrey, 
              foregroundColor: AppColors.white, 
              textStyle: AppTextStyles.buttonText, 
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), 
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), 
              ),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            labelStyle: AppTextStyles.labelText, 
            hintStyle: AppTextStyles.hintText,   
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)), 
              borderSide: BorderSide(color: AppColors.lightGrey), 
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: AppColors.lightGrey, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: AppColors.accentDarkGrey, width: 2), 
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15), 
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (_) => const SplashScreen(),
          '/login': (_) => const LoginPage(),
          '/register': (_) => const RegisterPage(),
          '/main': (_) => const MainPage(),
          '/forgot_password': (_) => const ForgotPasswordPage(),
        },
      ),
    );
  }
}
