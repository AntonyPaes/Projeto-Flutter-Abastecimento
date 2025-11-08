import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../screens/home_screen.dart';
import '../screens/vehicle_list_screen.dart';
import '../screens/history_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final authViewModel = context.read<AuthViewModel>();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text(
              "Bem-vindo",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            accountEmail: Text(
              user?.email ?? "Carregando...",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                user?.email?[0].toUpperCase() ?? "U",
                style: TextStyle(
                  fontSize: 40.0,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),

          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Página Inicial'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.directions_car),
            title: const Text('Meus Veículos'),
            onTap: () {
              // Navega para a lista de veículos
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const VehicleListScreen(),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.local_gas_station),
            title: const Text('Registrar Abastecimento'),
            onTap: () {
              // O melhor lugar para registrar é na tela de veículos
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const VehicleListScreen(),
                ),
              );
              // (O usuário selecionará um veículo para registrar)
            },
          ),

          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Histórico de Abastecimentos'),
            onTap: () {
              // Navega para a nova tela de histórico
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sair'),
            onTap: () {
              Navigator.pop(context); 
              authViewModel.signOut();
            },
          ),
        ],
      ),
    );
  }
}
