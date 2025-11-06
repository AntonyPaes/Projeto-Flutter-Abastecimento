import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/supply_model.dart';

class SupplyRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  SupplyRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> _getSuppliesCollection(
    String vehicleId,
  ) {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('Usuário não autenticado');
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('vehicles')
        .doc(vehicleId)
        .collection('supplies');
  }

  Stream<List<Supply>> getSupplies(String vehicleId) {
    return _getSuppliesCollection(
      vehicleId,
    ).orderBy('data', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Supply.fromSnapshot(doc)).toList();
    });
  }

  Future<void> addSupply(String vehicleId, Supply supply) async {
    try {
      await _getSuppliesCollection(vehicleId).add(supply.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteSupply(String vehicleId, String supplyId) async {
    try {
      await _getSuppliesCollection(vehicleId).doc(supplyId).delete();
    } catch (e) {
      rethrow;
    }
  }
}
