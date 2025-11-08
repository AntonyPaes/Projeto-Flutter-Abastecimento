// lib/repositories/supply_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/supply_model.dart';
import 'package:rxdart/rxdart.dart';

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

  Stream<List<Supply>> getAllSuppliesByUser() {
    return _auth.authStateChanges().switchMap((user) {
      if (user == null) {
        return Stream.value([]);
      } else {
        return _firestore
            .collection('users')
            .doc(user.uid)
            .collection('vehicles')
            .snapshots()
            .switchMap((vehicleSnapshot) {
              if (vehicleSnapshot.docs.isEmpty) {
                return Stream.value([]); // Se não há veículos, retorna vazio
              }
              // Para cada veículo, cria um stream de seus abastecimentos
              final List<Stream<List<Supply>>> suppliesStreams = vehicleSnapshot
                  .docs
                  .map((vehicleDoc) {
                    return _firestore
                        .collection('users')
                        .doc(user.uid)
                        .collection('vehicles')
                        .doc(vehicleDoc.id)
                        .collection('supplies')
                        .orderBy('data', descending: true)
                        .snapshots()
                        .map(
                          (supplySubSnapshot) => supplySubSnapshot.docs
                              .map(
                                (supplyDoc) => Supply.fromSnapshot(supplyDoc),
                              )
                              .toList(),
                        );
                  })
                  .toList();

              // Combina todos os streams de abastecimentos em um único stream
              // e os achata em uma única lista
              return Rx.combineLatestList(suppliesStreams).map((listOfLists) {
                return listOfLists.expand((list) => list).toList()..sort(
                  (a, b) => b.data.compareTo(a.data),
                ); // Ordena por data (mais recente primeiro)
              });
            });
      }
    });
  }
}
