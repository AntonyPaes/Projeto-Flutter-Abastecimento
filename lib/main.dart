import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // Ou StatefulWidget
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Retorne seu MaterialApp ou CupertinoApp aqui
    return MaterialApp(
      title: 'Projeto Abastecimento',
      home: Scaffold(
        appBar: AppBar(title: const Text('Meu App')),
        body: const Center(child: Text('Funciona!')),
      ),
    );
  }
}
