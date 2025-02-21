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
        List<List<dynamic>> csvTable = CsvToListConverter(eol: "\n").convert(
            content);

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

            print("Package loaded: ${package.countId} - ${package
                .length} x ${package.width} x ${package.height}");
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
          SnackBar(
              content: Text("No packages loaded! Please upload a valid CSV."))
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
      MaterialPageRoute(
          builder: (context) => ResultsScreen(lorry: loadedLorry)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.pink],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 10,
              top: 10, // Ensures the logo doesn't overlap content
              child: Image.asset(
                "assets/images/logoKerridge.png",
                height: 100,
              ),
            ),
            Center(
              child: SingleChildScrollView( // 🔥 Prevents bottom overflow
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    // Allows content to expand properly
                    constraints: const BoxConstraints(maxWidth: 400),
                    // Limits width for better UI
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                            Icons.cloud_upload, size: 50, color: Colors.pink),
                        const SizedBox(height: 10),
                        const Text(
                          "Please select your CSV file here:",
                          style: TextStyle(fontSize: 18,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: loadCSV,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text("Upload CSV"),
                        ),
                        if (packages.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Text(
                            "Loaded ${packages.length} packages.",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: goToResultsScreen,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text("View Results"),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}