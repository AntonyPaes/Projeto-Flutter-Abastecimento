import 'package:cloud_firestore/cloud_firestore.dart';

class Vehicle {
  final String? id;
  final String marca;
  final String modelo;
  final int ano;
  final String placa;

  Vehicle({
    this.id,
    required this.marca,
    required this.modelo,
    required this.ano,
    required this.placa,
  });

  Map<String, dynamic> toJson() {
    return {'marca': marca, 'modelo': modelo, 'ano': ano, 'placa': placa};
  }

  factory Vehicle.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Vehicle(
      id: doc.id,
      marca: data['marca'],
      modelo: data['modelo'],
      ano: data['ano'],
      placa: data['placa'],
    );
  }
}
