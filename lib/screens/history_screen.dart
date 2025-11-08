import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/supply_model.dart';
import '../viewmodels/supply_viewmodel.dart';
import '../widgets/app_drawer.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final supplyViewModel = context.watch<SupplyViewModel>();
    final supplies = supplyViewModel.allSupplies; // Pega a lista do ViewModel
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm'); // Formato com hora
    final currencyFormat = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(title: const Text('Histórico de Abastecimentos')),
      body: supplies.isEmpty
          ? const Center(
              child: Text('Nenhum abastecimento registrado em seus veículos.'),
            )
          : ListView.builder(
              itemCount: supplies.length,
              itemBuilder: (context, index) {
                final supply = supplies[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Data: ${dateFormat.format(supply.data)}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Valor Total: ${currencyFormat.format(supply.valorTotal)}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          'Litros: ${supply.litros.toStringAsFixed(2)} L',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          'KM: ${supply.kmAtual.toStringAsFixed(0)}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          'Valor por Litro: ${currencyFormat.format(supply.valorPorLitro)}/L',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
