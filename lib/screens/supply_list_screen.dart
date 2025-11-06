import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/vehicle_model.dart';
import '../models/supply_model.dart';
import '../repositories/supply_repository.dart';
import '../viewmodels/supply_viewmodel.dart';
import 'add_supply_screen.dart';

class SupplyListScreen extends StatelessWidget {
  final Vehicle vehicle;

  const SupplyListScreen({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final supplyViewModel = context.read<SupplyViewModel>();
    final dateFormat = DateFormat('dd/MM/yyyy');
    final currencyFormat = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );

    return StreamProvider<List<Supply>>.value(
      value: context.read<SupplyRepository>().getSupplies(vehicle.id!),
      initialData: [],
      catchError: (_, error) => [],
      child: Scaffold(
        appBar: AppBar(
          title: Text(vehicle.modelo),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddSupplyScreen(vehicleId: vehicle.id!),
                  ),
                );
              },
            ),
          ],
        ),
        body: Consumer<List<Supply>>(
          builder: (context, supplies, child) {
            if (supplies.isEmpty) {
              return const Center(
                child: Text('Nenhum abastecimento registrado.'),
              );
            }

            return ListView.builder(
              itemCount: supplies.length,
              itemBuilder: (context, index) {
                final supply = supplies[index];
                return Dismissible(
                  key: Key(supply.id!),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    supplyViewModel.deleteSupply(vehicle.id!, supply.id!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Abastecimento de ${dateFormat.format(supply.data)} deletado',
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text('Data: ${dateFormat.format(supply.data)}'),
                    subtitle: Text(
                      '${currencyFormat.format(supply.valorTotal)} (${supply.litros} L) - KM: ${supply.kmAtual}\n'
                      '${currencyFormat.format(supply.valorPorLitro)}/L',
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
