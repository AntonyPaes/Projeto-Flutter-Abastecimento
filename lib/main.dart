import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_options.dart';
import 'models/vehicle_model.dart';
import 'models/supply_model.dart';
import 'repositories/auth_repository.dart';
import 'repositories/vehicle_repository.dart';
import 'repositories/supply_repository.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/vehicle_viewmodel.dart';
import 'viewmodels/supply_viewmodel.dart';

import 'auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        // Auth
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
          catchError: (_, error) => [],
        ),

        Provider<SupplyRepository>(create: (_) => SupplyRepository()),
        ChangeNotifierProvider<SupplyViewModel>(
          create: (context) =>
              SupplyViewModel(repository: context.read<SupplyRepository>()),
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
      title: 'App MVVM Firebase',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      home: const AuthGate(),
    );
  }
}
