import 'package:flutter/material.dart';
import 'package_model.dart'; // Assuming this is your package model
import '../ui/layer_buttons.dart';

class Lorry {
  final int ID;
  final double length;
  final double width;
  final double doorheight;
  final int maxweight;
  final List<Package> packages;
  List<List<Offset>> packagePositionsByLayer = []; // Store positions of packages for each layer

  Lorry({
    required this.ID,
    this.length = 14.0,
    this.width = 2.8,
    this.doorheight = 2.8,
    this.maxweight = 10000,
    required this.packages,
  }) {
    packagePositionsByLayer = [];
    calculatePackagePositions(1.0); // Scale factor for packages
  }

  void calculatePackagePositions(double scale) {
    packagePositionsByLayer.clear();
    double maxWidth = length * 100 * scale; // Convert lorry length to cm
    double maxHeight = width * 100 * scale; // Convert lorry width to cm
    double currentHeight = 0.0; // Tracks the height for the current layer
    double xOffset = 0.0;  // Tracks horizontal position in the current layer
    double yOffset = 0.0;  // Tracks vertical position in the current layer
    double rowHeight = 0.0; // Max height for the current row (used for line wrapping)

    List<Offset> currentLayerPositions = [];

    for (var package in packages) {
      double packageWidth = package.length * scale;
      double packageHeight = package.width * scale;

      // Check if the current package fits in the current layer (height-wise)
      if (yOffset + packageHeight > maxHeight) {
        // Move to the next layer
        packagePositionsByLayer.add(currentLayerPositions);
        currentLayerPositions = [];
        yOffset = 0.0; // Reset vertical position
        currentHeight += rowHeight;
        rowHeight = 0.0;

        // If we exceed the total height of the lorry, stop adding packages
        if (currentHeight + packageHeight > maxHeight) {
          debugPrint("Stopped placing: Not enough space.");
          break;
        }
      }

      // Place the package
      currentLayerPositions.add(Offset(xOffset, yOffset));

      // Update xOffset for the next package in the row
      xOffset += packageWidth;

      // If the package is taller than the current row height, update rowHeight
      rowHeight = packageHeight > rowHeight ? packageHeight : rowHeight;

      // If the current package doesn't fit in the current row horizontally, start a new row
      if (xOffset + packageWidth > maxWidth) {
        xOffset = 0.0; // Reset to start of the next row
        yOffset += rowHeight; // Move to next vertical position
      }
    }

    if (currentLayerPositions.isNotEmpty) {
      packagePositionsByLayer.add(currentLayerPositions);
    }

    debugPrint("Package Positions by Layer: $packagePositionsByLayer");
  }
}
