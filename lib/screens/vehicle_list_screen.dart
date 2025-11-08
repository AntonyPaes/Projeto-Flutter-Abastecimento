import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/vehicle_model.dart';
import '../viewmodels/vehicle_viewmodel.dart';
import 'add_edit_vehicle_screen.dart';
import 'supply_list_screen.dart';
import '../widgets/app_drawer.dart';

class VehicleListScreen extends StatelessWidget {
  const VehicleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vehicleViewModel = context.read<VehicleViewModel>();
    final vehicles = context.watch<List<Vehicle>>();

    return Scaffold(
      drawer: const AppDrawer(),

      appBar: AppBar(
        title: const Text('Meus Veículos'),
      ),

      body: ListView.builder(
        itemCount: vehicles.length,
        itemBuilder: (context, index) {
          final vehicle = vehicles[index];

          return Dismissible(
            key: Key(vehicle.id ?? index.toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              if (vehicle.id != null) {
                vehicleViewModel.deleteVehicle(vehicle.id!);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${vehicle.modelo} deletado')),
                );
              }
            },
            child: ListTile(
              title: Text('${vehicle.marca} ${vehicle.modelo}'),
              subtitle: Text('Placa: ${vehicle.placa} - Ano: ${vehicle.ano}'),

              // Ao clicar no item, vai para a lista de abastecimentos
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SupplyListScreen(vehicle: vehicle),
                  ),
                );
              },

              // Botão de "editar" no final
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddEditVehicleScreen(vehicle: vehicle),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditVehicleScreen(),
            ),
          );
        },
      ),
    );
  }
}
