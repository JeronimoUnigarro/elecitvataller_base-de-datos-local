import 'package:flutter/material.dart';
import '../db/finance_db.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _type = "income";
  List<Map<String, dynamic>> transactions = [];
  double totalExpenses = 0.0; // 🔹 nuevo estado

  @override
  void initState() {
    super.initState();
    _loadTransactions();
    _loadTotalExpenses(); // 🔹 cargar gastos totales
  }

  Future<void> _loadTransactions() async {
    final data = await FinanceDB.instance.getTransactions();
    setState(() {
      transactions = data;
    });
  }

  Future<void> _loadTotalExpenses() async {
    final total = await FinanceDB.instance.getTotalExpenses();
    setState(() {
      totalExpenses = total;
    });
  }

  Future<void> _addTransaction() async {
    await FinanceDB.instance.addTransaction({
      'title': _titleController.text,
      'amount': double.tryParse(_amountController.text) ?? 0.0,
      'date': DateTime.now().toIso8601String(),
      'type': _type,
    });
    _titleController.clear();
    _amountController.clear();
    _loadTransactions();
    _loadTotalExpenses(); // 🔹 actualizar gastos totales al agregar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Finance Manager")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: "Title"),
                ),
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Amount"),
                ),
                DropdownButton<String>(
                  value: _type,
                  items: ["income", "expense"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => _type = val!),
                ),
                ElevatedButton(
                  onPressed: _addTransaction,
                  child: const Text("Add Transaction"),
                ),
                const SizedBox(height: 10),
                // 🔹 Mostrar total de gastos
                Text(
                  "Total Expenses: \$${totalExpenses.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final tx = transactions[index];
                return ListTile(
                  title: Text(tx['title']),
                  subtitle: Text("${tx['date']} - ${tx['type']}"),
                  trailing: Text("\$${tx['amount']}"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
