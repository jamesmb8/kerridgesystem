import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import '../ui/uploader_screen.dart';
import '../models/package_model.dart';

class FileLoader {
  //loads and takes each package from the CSV into the list packages
  static Future<List<Package>> loadCSV() async {
    //opens filepicker so the user can select their file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
      withData: true,
    );

    //if the user picks a file
    if (result != null) {
      final file = result.files.single; //gets the file
      final content = file.bytes != null
          ? utf8.decode(file.bytes!)
          : await File(file.path!).readAsString();

      List<List<dynamic>> csvTable = CsvToListConverter().convert(content);
      //turns csv to a list of rows

      List<Package> packages = [];

      //loops through each row, missing the headers
      for (int i = 1; i < csvTable.length; i++) {
        List<dynamic> row = csvTable[i];



        //creates the package objects
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
        //adds packages to the list

      }

      return packages;
    } else {
      throw Exception("No file selected");
    }
  }
}