import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'package:csv/csv.dart';
import '../models/package_model.dart';
import '../models/lorry_model.dart';
import 'results_screen.dart';

class UploaderScreen extends StatefulWidget {
  @override
  _UploaderScreenState createState() => _UploaderScreenState();
}

class _UploaderScreenState extends State<UploaderScreen> {
  List<Package> packages = [];

  Future<void> loadCSV() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null) {
        final bytes = result.files.single.bytes;
        final content = utf8.decode(bytes!);
        List<List<dynamic>> csvTable = CsvToListConverter(eol: "\n").convert(content);

        print("CSV Raw Data: $csvTable"); // Debugging: Check CSV contents

        if (csvTable.isEmpty) {
          print("CSV file is empty!");
          return;
        }

        List<Package> loadedPackages = [];

        for (int i = 1; i < csvTable.length; i++) { // Skip header row
          List<dynamic> row = csvTable[i];

          print("Row $i: $row"); // Debugging: Print each row

          try {
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

            print("Package loaded: ${package.countId} - ${package.length} x ${package.width} x ${package.height}");
            // Debugging: Show package object

            loadedPackages.add(package);
          } catch (e) {
            print("Error parsing row $i: $e");
          }
        }

        setState(() {
          packages = loadedPackages;
        });

        print("Successfully loaded ${packages.length} packages.");
      } else {
        print("No file selected.");
      }
    } catch (e) {
      print("Error loading CSV: $e");
    }
  }

  void goToResultsScreen() {
    if (packages.isEmpty) {
      print("Cannot proceed, no packages loaded.");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No packages loaded! Please upload a valid CSV."))
      );
      return;
    }

    Lorry loadedLorry = Lorry(
      ID: 1,
      length: 14.0,
      width: 2.8,
      doorheight: 2.8,
      maxweight: 10000,
      packages: packages,
    );

    print("Navigating to ResultsScreen with ${packages.length} packages.");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResultsScreen(lorry: loadedLorry)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload CSV")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: loadCSV,
              child: Text("Upload CSV"),
            ),
            SizedBox(height: 20),
            if (packages.isNotEmpty) ...[
              Text("Loaded ${packages.length} packages."),
              ElevatedButton(
                onPressed: goToResultsScreen,
                child: Text("View Results"),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
