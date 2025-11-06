import 'package:cloud_firestore/cloud_firestore.dart';

class Supply {
  final String? id;
  final DateTime data;
  final double litros;
  final double valorTotal;
  final double kmAtual;

  Supply({
    this.id,
    required this.data,
    required this.litros,
    required this.valorTotal,
    required this.kmAtual,
  });

  Map<String, dynamic> toJson() {
    return {
      'data': Timestamp.fromDate(data),
      'litros': litros,
      'valorTotal': valorTotal,
      'kmAtual': kmAtual,
    };
  }

  factory Supply.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Supply(
      id: doc.id,
      data: (data['data'] as Timestamp).toDate(),
      litros: data['litros'],
      valorTotal: data['valorTotal'],
      kmAtual: data['kmAtual'],
    );
  }

  double get valorPorLitro => valorTotal / litros;
}
