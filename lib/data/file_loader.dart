import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import '../ui/uploader_screen.dart';
import '../models/package_model.dart';

class FileLoader {
  static Future<List<Package>> loadCSV() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      final bytes = result.files.single.bytes;
      final content = utf8.decode(bytes!);
      List<List<dynamic>> csvTable = CsvToListConverter().convert(content);

      List<Package> packages = [];


      for (int i = 1; i < csvTable.length; i++) {
        List<dynamic> row = csvTable[i];

        // Check if the row has the expected number of columns

        Package package = Package(
          countId: int.tryParse(row[0].toString()) ?? 0,
          height: double.tryParse(row[1].toString()) ?? 0.0,
          length: double.tryParse(row[2].toString()) ?? 0.0,
          surfaceArea: double.tryParse(row[3].toString()) ?? 0.0,
          type: row[4].toString(),
          volume: double.tryParse(row[5].toString()) ?? 0.0,
          weight: double.tryParse(row[6].toString()) ?? 0.0,
          radius: double.tryParse(row[7].toString()) ?? 0.0,
          width: double.tryParse(row[8].toString()) ?? 0.0,
        );
        packages.add(package);

      }

      return packages;
    } else {
      throw Exception("No file selected");
    }
  }
}