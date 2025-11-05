import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> signIn({required String email, required String password}) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      await _authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        _setErrorMessage('E-mail ou senha incorretos.');
      } else {
        _setErrorMessage('Ocorreu um erro: ${e.message}');
      }
    } catch (e) {
      _setErrorMessage('Ocorreu um erro inesperado.');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signUp({required String email, required String password}) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      await _authRepository.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _setErrorMessage('A senha fornecida é muito fraca.');
      } else if (e.code == 'email-already-in-use') {
        _setErrorMessage('Este e-mail já está em uso.');
      } else {
        _setErrorMessage('Erro ao cadastrar: ${e.message}');
      }
    } catch (e) {
      _setErrorMessage('Ocorreu um erro inesperado.');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
  }
}
