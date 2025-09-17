import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ExportService {
  Future<String> exportCSV(List<Map<String, dynamic>> transactions) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = "${directory.path}/report.csv";

    final file = File(path);
    final sink = file.openWrite();

    sink.writeln("Title,Amount,Date,Type");

    for (var tx in transactions) {
      sink.writeln(
        "${tx['title']},${tx['amount']},${tx['date']},${tx['type']}",
      );
    }

    await sink.close();
    return path;
  }
}
