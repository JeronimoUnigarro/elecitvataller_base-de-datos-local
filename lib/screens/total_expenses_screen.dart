import 'package:flutter/material.dart';
import '../db/finance_db.dart';

class TotalExpensesScreen extends StatefulWidget {
  const TotalExpensesScreen({super.key});

  @override
  State<TotalExpensesScreen> createState() => _TotalExpensesScreenState();
}

class _TotalExpensesScreenState extends State<TotalExpensesScreen> {
  double _totalExpenses = 0.0;

  @override
  void initState() {
    super.initState();
    _loadTotalExpenses();
  }

  void _loadTotalExpenses() async {
    // Usar el singleton instance en vez de llamar al constructor
    double total = await FinanceDB.instance.getTotalExpenses();
    if (!mounted) return;
    setState(() {
      _totalExpenses = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gastos Totales")),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Text(
              "Tus gastos totales: \$${_totalExpenses.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
