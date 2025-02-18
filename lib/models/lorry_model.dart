import 'package_model.dart';
import 'package:flutter/material.dart';

class Lorry {
  final int ID;
  final double length;
  final double width;
  final double doorheight;
  final int maxweight;
  final List<Package> packages;
  List<Offset> packagePositions = []; // To store the position of each package

  Lorry({
    required this.ID,
    this.length = 14.0,
    this.width = 2.8,
    this.doorheight = 2.8,
    this.maxweight = 10000,
    required this.packages,
  }) {
    packagePositions = []; // Clear previous positions
    calculatePackagePositions(1.0); // Default scale (adjust later)
  }

  // Method to calculate the position of each package inside the lorry
  void calculatePackagePositions(double scale) {
    packagePositions.clear();

    double maxWidth = length * 100 * scale; // Convert lorry length to cm
    double maxHeight = width * 100 * scale; // Convert lorry width to cm

    debugPrint("Lorry Size: ${length * 100}cm x ${width * 100}cm (Scaled: $maxWidth x $maxHeight)");

    double xOffset = 0.0;
    double yOffset = 0.0;
    double rowHeight = 0.0;

    for (var package in packages) {
      double packageWidth = package.width * scale;  // Already in cm from CSV
      double packageHeight = package.length * scale; // Already in cm from CSV

      debugPrint("Package Size: ${package.width}cm x ${package.length}cm (Scaled: $packageWidth x $packageHeight)");

      // Prevent overflow
      if (xOffset + packageWidth > maxWidth) {
        xOffset = 0.0;
        yOffset += rowHeight;
        rowHeight = 0.0;
      }

      if (yOffset + packageHeight > maxHeight) {
        debugPrint("Stopped placing: Not enough space.");
        break; // Stop placing packages if there's no space
      }

      packagePositions.add(Offset(xOffset, yOffset));
      debugPrint("Placed at: ($xOffset, $yOffset)");

      xOffset += packageWidth;
      rowHeight = packageHeight > rowHeight ? packageHeight : rowHeight;
    }

    debugPrint("Final Package Positions: $packagePositions");
  }

}