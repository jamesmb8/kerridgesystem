import 'package_model.dart';
import 'package:flutter/material.dart';

class Lorry {
  final int ID;
  final double length;
  final double width;
  final double doorheight;
  final int maxweight;
  final List<Package> packages;
  List<Offset> packagePositions = [];

  static const double padding = 2.0; // Small padding between packages

  Lorry({
    required this.ID,
    this.length = 14.0,
    this.width = 2.8,
    this.doorheight = 2.8,
    this.maxweight = 10000,
    required this.packages,
  }) {
    packagePositions = [];
    calculatePackagePositions(1.0);
  }

  void calculatePackagePositions(double scale) {
    packagePositions.clear();

    double maxWidth = length * 100 * scale;
    double maxHeight = width * 100 * scale;

    debugPrint("Lorry Size: ${length * 100}cm x ${width * 100}cm (Scaled: $maxWidth x $maxHeight)");

    // Sort packages by height * width (largest first)
    packages.sort((a, b) => (b.length * b.width).compareTo(a.length * a.width));

    List<Rect> placedPackages = [];
    List<Offset> availableSpaces = [Offset(0, 0)];

    for (var package in packages) {
      double packageWidth = (package.width * scale) + padding;
      double packageHeight = (package.length * scale) + padding;

      debugPrint("Package Size: ${package.width}cm x ${package.length}cm (Scaled: $packageWidth x $packageHeight)");

      Offset? bestPosition;
      double minWastedSpace = double.infinity;

      for (var space in availableSpaces) {
        Rect newPackage = Rect.fromLTWH(space.dx, space.dy, packageWidth, packageHeight);

        // Ensure the new package does NOT overlap with existing ones
        bool overlaps = placedPackages.any((p) => p.overlaps(newPackage));
        if (overlaps) continue;

        // Ensure it fits in the lorry
        if (space.dx + packageWidth <= maxWidth && space.dy + packageHeight <= maxHeight) {
          double wastedSpace = (maxWidth - (space.dx + packageWidth)) + (maxHeight - (space.dy + packageHeight));

          if (wastedSpace < minWastedSpace) {
            bestPosition = space;
            minWastedSpace = wastedSpace;
          }
        }
      }

      if (bestPosition == null) {
        debugPrint("No available space found for package.");
        break;
      }

      packagePositions.add(bestPosition);
      Rect placedPackage = Rect.fromLTWH(bestPosition.dx, bestPosition.dy, packageWidth, packageHeight);
      placedPackages.add(placedPackage);

      debugPrint("Placed at: (${bestPosition.dx}, ${bestPosition.dy})");

      // Remove overlapping spaces
      availableSpaces.removeWhere((space) => placedPackages.any((p) => p.contains(space)));

      // Add new valid positions (left to right filling)
      availableSpaces.add(Offset(bestPosition.dx + packageWidth, bestPosition.dy)); // Right side
      availableSpaces.add(Offset(bestPosition.dx, bestPosition.dy + packageHeight)); // Bottom side

      // Sort spaces to prioritize filling from left to right
      availableSpaces.sort((a, b) => (a.dx == b.dx) ? a.dy.compareTo(b.dy) : a.dx.compareTo(b.dx));
    }

    debugPrint("Final Package Positions: $packagePositions");
  }
}
