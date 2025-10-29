import 'package:flutter/material.dart';
import 'app_colors.dart'; 

class AppTextStyles {
  // Başlıklar için
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: 'Poppins', 
    fontSize: 34, 
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 28, 
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  // Gövde metinleri için
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 20, 
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 18, 
    color: AppColors.textPrimary,
  );

  // Buton ve etiketler için
  static const TextStyle buttonText = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 20, 
    fontWeight: FontWeight.bold,
    color: AppColors.white, 
  );

  static const TextStyle labelText = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 18, 
    color: AppColors.textSecondary,
  );

  static const TextStyle hintText = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16, 
    color: AppColors.textSecondary,
  );

  // Küçük metinler (tarih, not vb.)
  static const TextStyle captionText = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14,
    color: AppColors.textSecondary,
  );
}