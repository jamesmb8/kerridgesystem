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

    const totalLayers = 5;
    final maxWidth = length * 100;
    final maxDepth = width * 100;

    final List<List<Rect>> layerRects = List.generate(totalLayers, (_) => []);
    final List<List<double>> layerWeights = List.generate(totalLayers, (_) => []);

    packages.sort((a, b) {
      final aMetric = a.length * a.width * a.height;
      final bMetric = b.length * b.width * b.height;
      return bMetric.compareTo(aMetric); // largest volume first
    });

    for (final pkg in packages) {
      final w = pkg.width + padding;
      final d = pkg.length + padding;
      final h = pkg.height;
      final vol = w * d * h;

      final layersRequired = (h / layerHeight).ceil();
      bool placed = false;

      for (int layer = 0; layer <= totalLayers - layersRequired; layer++) {
        final avgBelowWeight = layer == 0
            ? double.infinity
            : layerWeights.sublist(0, layer).expand((e) => e).fold(0.0, (a, b) => a + b) /
            layerWeights.sublist(0, layer).expand((e) => e).length;

        if (pkg.weight > avgBelowWeight) continue;

        for (double x = 0; x <= maxWidth - w; x += 5) {
          for (double y = 0; y <= maxDepth - d; y += 5) {
            final candidate = Rect.fromLTWH(x, y, w, d);
            final overlaps = layerRects
                .sublist(layer, layer + layersRequired)
                .any((rects) => rects.any((r) => r.overlaps(candidate)));

            if (!overlaps) {
              for (int l = layer; l < layer + layersRequired; l++) {
                layerRects[l].add(candidate);
                layerWeights[l].add(pkg.weight);
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

              debugPrint("✅ Placed package ID=${pkg.countId} on layer ${layer + 1}");
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
