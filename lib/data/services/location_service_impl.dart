import 'dart:async'; // TimeoutException için gerekli
import 'package:geolocator/geolocator.dart';
import '../../domain/services/location_service.dart';

class LocationServiceImpl implements LocationService {
  @override
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Konum servislerinin etkin olup olmadığını kontrol et
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Konum servisleri etkin değilse, kullanıcıya uyarı göster veya ayarlara yönlendir
      throw Exception('Konum servisleri kapalı.');
    }

    // Konum izinlerini kontrol et ve iste
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Konum izinleri reddedildi.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // İzinler kalıcı olarak reddedildi, uygulama ayarlarından açılmasını iste
      throw Exception(
          'Konum izinleri kalıcı olarak reddedildi. Lütfen uygulama ayarlarından izinleri verin.');
    }

    // Konum izinleri verilmiş ve servisler etkinse mevcut konumu al
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        // forceAndroidLocationManager: false, // Android için konum yöneticisini zorunlu kılma
      ).timeout(const Duration(seconds: 20)); 
    } on TimeoutException {
      // Geolocator'dan gelen zaman aşımı hatasını yakala
      throw Exception('Konum alınamadı, zaman aşımı oluştu. Lütfen tekrar deneyin.');
    } catch (e) {
      // Diğer tüm hataları yakala
      throw Exception('Konum alınırken bilinmeyen bir hata oluştu: ${e.toString()}');
    }
  }
}