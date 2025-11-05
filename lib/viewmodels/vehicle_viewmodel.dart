import 'package:flutter/material.dart';
import '../models/vehicle_model.dart';
import '../repositories/vehicle_repository.dart';

class VehicleViewModel extends ChangeNotifier {
  final VehicleRepository _repository;

  VehicleViewModel({required VehicleRepository repository})
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

  Future<bool> addVehicle({
    required String marca,
    required String modelo,
    required String ano,
    required String placa,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      final intAno = int.tryParse(ano);
      if (intAno == null) {
        _setError('Ano inválido');
        _setLoading(false);
        return false;
      }

      final vehicle = Vehicle(
        marca: marca,
        modelo: modelo,
        ano: intAno,
        placa: placa,
      );
      await _repository.addVehicle(vehicle);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Erro ao adicionar veículo: $e');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> updateVehicle({
    required String id,
    required String marca,
    required String modelo,
    required String ano,
    required String placa,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      final intAno = int.tryParse(ano);
      if (intAno == null) {
        _setError('Ano inválido');
        _setLoading(false);
        return false;
      }

      final vehicle = Vehicle(
        id: id,
        marca: marca,
        modelo: modelo,
        ano: intAno,
        placa: placa,
      );
      await _repository.updateVehicle(vehicle);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Erro ao atualizar veículo: $e');
      _setLoading(false);
      return false;
    }
  }

  Future<void> deleteVehicle(String vehicleId) async {
    _setLoading(true);
    _setError(null);
    try {
      await _repository.deleteVehicle(vehicleId);
    } catch (e) {
      _setError('Erro ao deletar veículo: $e');
    } finally {
      _setLoading(false);
    }
  }
}
