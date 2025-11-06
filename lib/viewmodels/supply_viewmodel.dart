import 'package:flutter/material.dart';
import '../models/supply_model.dart';
import '../repositories/supply_repository.dart';

class SupplyViewModel extends ChangeNotifier {
  final SupplyRepository _repository;

  SupplyViewModel({required SupplyRepository repository})
    : _repository = repository;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<bool> addSupply({
    required String vehicleId,
    required DateTime data,
    required String litros,
    required String valorTotal,
    required String kmAtual,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      final doubleLitros = double.tryParse(litros);
      final doubleValor = double.tryParse(valorTotal);
      final doubleKm = double.tryParse(kmAtual);

      if (doubleLitros == null || doubleValor == null || doubleKm == null) {
        _setError('Valores numéricos inválidos');
        _setLoading(false);
        return false;
      }

      final supply = Supply(
        data: data,
        litros: doubleLitros,
        valorTotal: doubleValor,
        kmAtual: doubleKm,
      );
      await _repository.addSupply(vehicleId, supply);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Erro ao adicionar abastecimento: $e');
      _setLoading(false);
      return false;
    }
  }

  Future<void> deleteSupply(String vehicleId, String supplyId) async {
    _setLoading(true);
    _setError(null);
    try {
      await _repository.deleteSupply(vehicleId, supplyId);
    } catch (e) {
      _setError('Erro ao deletar abastecimento: $e');
    } finally {
      _setLoading(false);
    }
  }
}
