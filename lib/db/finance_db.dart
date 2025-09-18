import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FinanceDB {
  static final FinanceDB instance = FinanceDB._init();
  static Database? _database;

  FinanceDB._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('finance.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        type TEXT NOT NULL
      )
    ''');
  }

  // Insertar transacción
  Future<int> addTransaction(Map<String, dynamic> transaction) async {
    final db = await instance.database;
    return await db.insert('transactions', transaction);
  }

  // Consultar transacciones
  Future<List<Map<String, dynamic>>> getTransactions() async {
    final db = await instance.database;
    return await db.query('transactions', orderBy: "date DESC");
  }

  // 🔹 Nuevo: calcular gastos totales
  Future<double> getTotalExpenses() async {
    final db = await instance.database;
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM transactions WHERE type = ?',
      ['expense'],
    );

    // Si hay registros devuelve la suma, si no, devuelve 0.0
    double total = result.first['total'] != null
        ? (result.first['total'] as num).toDouble()
        : 0.0;

    return total;
  }
}
