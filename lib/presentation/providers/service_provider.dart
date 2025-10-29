import 'package:flutter/material.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get_it/get_it.dart';
import '../../data/models/service_model.dart'; 
import '../../domain/repositories/service_repository.dart';
import '../../domain/services/location_service.dart';
import 'package:project/data/repositories/service_repository_impl.dart';




class ServiceProvider with ChangeNotifier {
  final LocationService _locationService = GetIt.instance<LocationService>();
  final ServiceRepository _serviceRepository = GetIt.instance<ServiceRepository>();
 
  List<ServiceModel> _services = [];
  String? _currentCity; 
  bool _isLoading = false;
  String? _errorMessage;

  List<ServiceModel> get services => _services;
  String? get currentCity => _currentCity; 
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  ServiceProvider();
  
  Future<void> fetchServicesForCurrentCity() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try{
      Position position = await _locationService.getCurrentLocation();
      _currentCity = await _getCityFromCoordinates(position.latitude, position.longitude);
      if (_currentCity == null) {
        _services = [];
        _errorMessage = 'Konum tespit edilemedi. Lütfen konum servislerinizi kontrol edin.';
      } else { 
        _services = await _serviceRepository.getServicesByCity(_currentCity!);
        if (_services.isEmpty) {
          _errorMessage = '$_currentCity için henüz hiç hizmet bulunmamaktadır.';
        }
      }
    } catch (e) {
      _errorMessage = e.toString();
      _services = [];
      print('Hizmetleri getirirken hata: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  // Geçici çözüm: Koordinatlara göre bilinen şehir tespiti
  Future<String?> _getCityFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        return placemarks.first.locality?.toLowerCase();
      }
    } catch (e) {
      print("Geocoding hatası: $e");
    }

    // Ankara
    if (latitude > 39.7 && latitude < 40.0 && longitude > 32.5 && longitude < 33.3) {
      return "Ankara";
    }
    // İzmir
    else if (latitude > 38.0 && latitude < 38.6 && longitude > 26.5 && longitude < 27.5) {
      return "İzmir";
    }
    // İstanbul
    else if (latitude > 40.8 && latitude < 41.3 && longitude > 28.5 && longitude < 29.5) {
      return "İstanbul";
    }
    // Samsun
    else if (latitude > 41.25 && latitude < 41.35 && longitude > 36.25 && longitude < 36.45) {
      return "Samsun";
    }
    // Varsayılan
    return null;
  }
}