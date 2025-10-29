import '../../domain/repositories/service_repository.dart';
import '../models/service_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Future<List<ServiceModel>> getServicesByCity(String city) async {
    try{
      final QuerySnapshot= await _firestore
          .collection('services')
          .where('city', isEqualTo: city.toLowerCase())
          .get();
      return QuerySnapshot.docs.map((doc) {
        return ServiceModel.fromMap(doc.id, doc.data());
      }).toList();
    } catch (e) {
      print('Error fetching services by city: $e');
      return[];
    }
    
  }
}