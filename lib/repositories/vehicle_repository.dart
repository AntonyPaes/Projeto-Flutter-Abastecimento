import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/vehicle_model.dart';
import 'package:rxdart/rxdart.dart';

class VehicleRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  VehicleRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> _getVehiclesCollection() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('Usuário não autenticado');
    return _firestore.collection('users').doc(uid).collection('vehicles');
  }
  Stream<List<Vehicle>> getVehicles() {
    return _auth.authStateChanges().switchMap((user) {
      if (user == null) {
        return Stream.value([]);
      } else {
        return _firestore
            .collection('users')
            .doc(user.uid)
            .collection('vehicles')
            .orderBy('marca')
            .snapshots()
            .map((snapshot) {
              return snapshot.docs
                  .map((doc) => Vehicle.fromSnapshot(doc))
                  .toList();
            });
      }
    });
  }

  Future<void> addVehicle(Vehicle vehicle) async {
    try {
      await _getVehiclesCollection().add(vehicle.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateVehicle(Vehicle vehicle) async {
    try {
      if (vehicle.id == null) throw Exception('ID do veículo é nulo');
      await _getVehiclesCollection().doc(vehicle.id).update(vehicle.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteVehicle(String vehicleId) async {
    try {
      await _getVehiclesCollection().doc(vehicleId).delete();
    } catch (e) {
      rethrow;
    }
  }
}