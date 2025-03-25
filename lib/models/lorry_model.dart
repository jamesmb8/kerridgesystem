import 'package_model.dart';
import 'package:flutter/material.dart';
import '../ui/lorry_painter.dart';



class Lorry {
  final int ID;
  final double length;
  final double width;
  final double doorheight;
  final int maxweight;
  final List<Package> packages;

  List<Map<String, dynamic>> packagePositions = [];

  static const double padding = 2.0;
  static const double maxLorryHeight = 280.0;
  static const double layerHeight = maxLorryHeight / 5;

  Lorry({
    required this.ID,
    this.length = 14.0,
    this.width = 2.8,
    this.doorheight = 2.8,
    this.maxweight = 10000,
    required this.packages,
  });

  void calculatePackagePositions(double scale) {
    debugPrint("Running calculatePackagePositions...");
    packagePositions.clear();

    final maxWidth = length * 100;
    final maxDepth = width * 100;

    packages.sort((a, b) => b.weight.compareTo(a.weight));

    List<List<Rect>> layerRects = List.generate(5, (_) => []);

    for (var pkg in packages) {
      double w = pkg.width + padding;
      double d = pkg.length + padding;
      double h = pkg.height;

      debugPrint("Trying to place package ID=${pkg.countId}, Size=(${w}x${d}x${h})");

      int requiredLayers = (h / layerHeight).ceil();

      bool placed = false;

      for (int layer = 0; layer <= 5 - requiredLayers; layer++) {
        for (double x = 0; x <= maxWidth - w; x += 5) {
          for (double y = 0; y <= maxDepth - d; y += 5) {
            final candidate = Rect.fromLTWH(x, y, w, d);

            final overlap = layerRects
                .sublist(layer, layer + requiredLayers)
                .any((layerList) => layerList.any((r) => r.overlaps(candidate)));

            if (!overlap) {
              for (int l = layer; l < layer + requiredLayers; l++) {
                layerRects[l].add(candidate);
              }

              pkg.assignedLayer = layer + 1;

              packagePositions.add({
                "x": x,
                "y": y,
                "width": w,
                "depth": d,
                "height": h,
                "layer": layer + 1,
                "countId": pkg.countId,
              });

              debugPrint("Placed package ID=${pkg.countId} at ($x, $y) on layer ${layer + 1}");
              placed = true;
              break;
            }
          }
          if (placed) break;
        }
        if (placed) break;
      }

      if (!placed) {
        debugPrint("⚠️ Could not place package ID=${pkg.countId}");
      }
    }

    debugPrint("✅ Finished placement: ${packagePositions.length} packages placed");
  }
}
