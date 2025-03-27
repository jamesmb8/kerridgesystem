import 'package_model.dart';
import 'package:flutter/material.dart';
import '../ui/lorry_painter.dart';


//creating the lorry class
class Lorry {
  final int ID;
  final double length;
  final double width;
  final double doorheight;
  final int maxweight;
  final List<Package> packages;

  List<Map<String, dynamic>> packagePositions = [];
  //stores placement details we ue in the pdf's

  //the constants
  static const double padding = 2.0;
  static const double maxLorryHeight = 280.0;
  static const double layerHeight = maxLorryHeight / 5;

  final List<List<Rect>> layerRects = List.generate(5, (_) => []);
  //holds all packages in the layers
  final List<List<double>> layerWeights = List.generate(5, (_) => []);
  //checks each layer weight

//creating the lorry instance
  Lorry({
    required this.ID,
    this.length = 14.0,
    this.width = 2.8,
    this.doorheight = 2.8,
    this.maxweight = 10000,
    required this.packages,
  });

  bool tryPlacePackage(Package pkg) {


    final w = pkg.width + padding;
    final d = pkg.length + padding;
    final h = pkg.height;

    final maxWidth = length * 100;
    final maxDepth = width * 100;
    final layersRequired = (h / layerHeight).ceil();
    //adding padding on to packages and see's how many lyers left

    for (int layer = 0; layer <= 5 - layersRequired; layer++) {
      //Trys to place in first layer each time
      final avgBelowWeight = layer == 0
          ? double.infinity
          : layerWeights.sublist(0, layer).expand((e) => e).fold(0.0, (a, b) => a + b) /
          layerWeights.sublist(0, layer).expand((e) => e).length;
      //calculate average weight in layers below the current one

      if (pkg.weight > avgBelowWeight) continue;
      //if package is now too heavy it wont be placed

      for (double x = 0; x <= maxWidth - w; x += 5) {
        for (double y = 0; y <= maxDepth - d; y += 5) {
          //brute force every x and y position in the grid, with 5 cm increments
          final candidate = Rect.fromLTWH(x, y, w, d);
          final overlaps = layerRects
          //check for overlaps
              .sublist(layer, layer + layersRequired)
              .any((rects) => rects.any((r) => r.overlaps(candidate)));

          if (!overlaps) {
            for (int l = layer; l < layer + layersRequired; l++) {
              layerRects[l].add(candidate);
              layerWeights[l].add(pkg.weight);
              //add the package in the layer and weight
            }

            pkg.assignedLayer = layer + 1;
            pkg.assignedLorryId = ID;
            packages.add(pkg);
            //add this info into packages

            packagePositions.add({
              "x": x,
              "y": y,
              "width": w,
              "depth": d,
              "height": h,
              "layer": layer + 1,
              "countId": pkg.countId,
              "lorryId": ID,
            });
            //save the exact spot

            return true;
          }
        }
      }
    }

    return false;
  }


}
