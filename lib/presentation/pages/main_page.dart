import 'package:flutter/material.dart';
import 'package:project/presentation/pages/login_page.dart';
import 'package:provider/provider.dart';
import 'package:project/presentation/providers/auth_provider.dart';
import 'package:project/presentation/providers/service_provider.dart';
import 'package:project/data/models/service_model.dart'; 
import 'package:project/core/constants/app_colors.dart';
import 'package:project/core/constants/app_text_styles.dart';



class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ServiceProvider>(context, listen: false).fetchServicesForCurrentCity();
    });
    
  }

  @override
  Widget build(BuildContext context) {
    final serviceProvider = Provider.of<ServiceProvider>(context); 
    if (serviceProvider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (serviceProvider.errorMessage != null) {
      return Center(
        child: Text(
          serviceProvider.errorMessage!,
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.errorRed),
        ),
      );
    }

    return ListView.builder(
      itemCount: serviceProvider.services.length,
      itemBuilder: (context, index) {
        final service = serviceProvider.services[index];
        return ListTile(
          title: Text(service.name, style: AppTextStyles.headlineMedium),
          subtitle: Text(service.description, style: AppTextStyles.bodyMedium),
        
        );
      }
    );
  }
}  
