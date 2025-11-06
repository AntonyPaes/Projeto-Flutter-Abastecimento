import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../viewmodels/supply_viewmodel.dart';

class AddSupplyScreen extends StatefulWidget {
  final String vehicleId;
  const AddSupplyScreen({super.key, required this.vehicleId});

  @override
  State<AddSupplyScreen> createState() => _AddSupplyScreenState();
}

class _AddSupplyScreenState extends State<AddSupplyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dataController = TextEditingController();
  final _litrosController = TextEditingController();
  final _valorTotalController = TextEditingController();
  final _kmAtualController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _updateDateText();
  }

  void _updateDateText() {
    _dataController.text = DateFormat('dd/MM/yyyy').format(_selectedDate);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      locale: const Locale('pt', 'BR'),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _updateDateText();
      });
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final viewModel = context.read<SupplyViewModel>();
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      final navigator = Navigator.of(context);

      final success = await viewModel.addSupply(
        vehicleId: widget.vehicleId,
        data: _selectedDate,
        litros: _litrosController.text,
        valorTotal: _valorTotalController.text,
        kmAtual: _kmAtualController.text,
      );

      if (success) {
        navigator.pop();
      } else if (viewModel.errorMessage != null) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(viewModel.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SupplyViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Abastecimento')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _dataController,
                decoration: const InputDecoration(labelText: 'Data'),
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
              TextFormField(
                controller: _litrosController,
                decoration: const InputDecoration(labelText: 'Litros'),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                validator: (value) =>
                    (value?.isEmpty ?? true) ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: _valorTotalController,
                decoration: const InputDecoration(
                  labelText: 'Valor Total (R\$)',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                validator: (value) =>
                    (value?.isEmpty ?? true) ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: _kmAtualController,
                decoration: const InputDecoration(labelText: 'KM Atual'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) =>
                    (value?.isEmpty ?? true) ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 20),
              if (viewModel.isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(onPressed: _submit, child: const Text('Salvar')),
            ],
          ),
        ),
      ),
    );
  }
}
