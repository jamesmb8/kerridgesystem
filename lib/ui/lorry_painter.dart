import 'package:flutter/material.dart';
import '../models/package_model.dart';
import '../models/lorry_model.dart';

class LorryPainter extends CustomPainter {
  final Lorry lorry;
  final double scale;
  final int selectedLayer;

  LorryPainter({required this.lorry, required this.scale, required this.selectedLayer});

  @override
  void paint(Canvas canvas, Size size) {
    double lorryWidth = lorry.width * 100 * scale;
    double lorryLength = lorry.length * 100 * scale;


    double lorryX = (size.width - lorryLength) / 2;
    double lorryY = (size.height - lorryWidth) / 2;



    Paint lorryBorderPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    Rect lorryRect = Rect.fromLTWH(lorryX, lorryY, lorryLength, lorryWidth);
    canvas.drawRect(lorryRect, lorryBorderPaint);

    // Draw packages using precomputed positions
    Paint packagePaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;

    for (int i = 0; i < lorry.packagePositions.length; i++) {
      Package package = lorry.packages[i];
      int startLayer = package.assignedLayer;
      int endLayer = startLayer + (package.height / 56).ceil() - 1;

      if (selectedLayer >= startLayer && selectedLayer <= endLayer) {
        Offset pos = lorry.packagePositions[i];

        double packageWidth = package.width * scale; // Package width in cm
        double packageHeight = package.length * scale; // Package height in cm

        Rect packageRect = Rect.fromLTWH(
            lorryX + pos.dx, lorryY + pos.dy, packageWidth, packageHeight);
        canvas.drawRect(packageRect, packagePaint);

        // Draw package ID
        TextPainter textPainter = TextPainter(
          text: TextSpan(
            text: '${package.countId}',
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        )
          ..layout(minWidth: 0, maxWidth: packageWidth);

        textPainter.paint(
          canvas,
          Offset(lorryX + pos.dx + (packageWidth - textPainter.width) / 2,
              lorryY + pos.dy + (packageHeight - textPainter.height) / 2),
        );
      }
    }

  }

    @override
    bool shouldRepaint(covariant LorryPainter oldDelegate) {
      return oldDelegate.selectedLayer != selectedLayer ||
          oldDelegate.scale != scale ||
          oldDelegate.lorry != lorry;
    }
  }
