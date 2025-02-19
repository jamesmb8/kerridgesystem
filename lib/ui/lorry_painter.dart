import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../models/package_model.dart';
import '../models/lorry_model.dart';
import 'uploader_screen.dart';
import '../data/file_loader.dart';
import '../ui/layer_buttons.dart';

class LorryPainter extends CustomPainter {
  final Lorry lorry;
  final double scale;
  final int selectedLayer; // Added to manage layer selection

  LorryPainter({required this.lorry, required this.scale, required this.selectedLayer});

  @override
  void paint(Canvas canvas, Size size) {
    double lorryX = 0.0; // X position of the lorry
    double lorryY = 0.0; // Y position of the lorry
    double lorryWidth = lorry.width * scale;
    double lorryHeight = lorry.length * scale;

    Paint lorryPaint = Paint()..color = Colors.grey.shade300; // Lorry base paint (gray)
    Paint packagePaint = Paint()..color = Colors.blue; // Package paint (blue)

    // Draw the base lorry (a large rectangle)
    Rect lorryRect = Rect.fromLTWH(lorryX, lorryY, lorryWidth, lorryHeight);
    canvas.drawRect(lorryRect, lorryPaint);

    // Draw the packages on the selected layer
    List<Offset> currentLayer = lorry.packagePositionsByLayer[selectedLayer - 1];

    // Loop through each package in the selected layer
    for (int i = 0; i < currentLayer.length; i++) {
      Offset pos = currentLayer[i];
      Package package = lorry.packages[i];

      double packageWidth = package.width * scale;  // Package width in cm
      double packageHeight = package.length * scale; // Package height in cm

      // Draw the package as a rectangle
      Rect packageRect = Rect.fromLTWH(lorryX + pos.dx, lorryY + pos.dy, packageWidth, packageHeight);
      canvas.drawRect(packageRect, packagePaint);

      // Draw package ID text on the package
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: '${package.countId}',
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )..layout(minWidth: 0, maxWidth: packageWidth);

      textPainter.paint(
        canvas,
        Offset(lorryX + pos.dx + (packageWidth - textPainter.width) / 2,
            lorryY + pos.dy + (packageHeight - textPainter.height) / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;  // You can refine this logic if needed (e.g., only repaint if something changes)
  }
}