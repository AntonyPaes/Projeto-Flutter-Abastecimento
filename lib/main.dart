import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'models/vehicle_model.dart';
import 'repositories/auth_repository.dart';
import 'repositories/vehicle_repository.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/vehicle_viewmodel.dart';
import 'auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthRepository>(create: (_) => AuthRepository()),
        ChangeNotifierProvider<AuthViewModel>(
          create: (context) =>
              AuthViewModel(authRepository: context.read<AuthRepository>()),
        ),

        Provider<VehicleRepository>(create: (_) => VehicleRepository()),
        ChangeNotifierProvider<VehicleViewModel>(
          create: (context) =>
              VehicleViewModel(repository: context.read<VehicleRepository>()),
        ),

        StreamProvider<List<Vehicle>>(
          create: (context) => context.read<VehicleRepository>().getVehicles(),
          initialData: [],
          catchError: (_, error) => [
            Vehicle(
              id: 'error',
              marca: 'Erro ao carregar',
              modelo: error.toString(),
              ano: 0,
              placa: '',
            ),
          ],
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Abastecimento',
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
    );
  }
}
