import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../models/package_model.dart';
import '../models/lorry_model.dart';
import 'uploader_screen.dart';
import '../data/file_loader.dart';



class LorryPainter extends CustomPainter {
  final Lorry lorry;
  final double scale;
  final int selectedLayer;
  final int? highlightedPackageId;
  //class for lorry painting


  LorryPainter({required this.lorry, required this.scale, required this.selectedLayer, this.highlightedPackageId});

  @override
  void paint(Canvas canvas, Size size) {
    double lorryWidth = lorry.width * 100 * scale;
    double lorryLength = lorry.length * 100 * scale;
    //convert lorry to cm then to pixels
    double lorryX = (size.width - lorryLength) / 2;
    double lorryY = (size.height - lorryWidth) / 2;
    //centres the lorry

    final borderPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawRect(Rect.fromLTWH(lorryX, lorryY, lorryLength, lorryWidth), borderPaint);
    //draw the lorry

    final layerColors = [
      Color(0xFFE69F00), // Orange
      Color(0xFF56B4E9), // Sky blue
      Color(0xFF009E73), // Teal green
      Color(0xFFF0E442), // Yellow
      Color(0xFF0072B2), // Blue
    ];
    const double layerHeight = Lorry.maxLorryHeight / 5;
    //sorting layer colours

    for (final pkg in lorry.packagePositions) {
      final startLayer = pkg["layer"];
      final layerSpan = (pkg["height"] / layerHeight).ceil();
      //go through every package

      if (selectedLayer < startLayer || selectedLayer >= startLayer + layerSpan) continue;

      final color = layerColors[(startLayer - 1) % layerColors.length];
      final fillPaint = Paint()..color = color;

      final x = lorryX + pkg["x"] * scale;
      final y = lorryY + pkg["y"] * scale;
      final w = pkg["width"] * scale;
      final d = pkg["depth"] * scale;

      canvas.drawRect(Rect.fromLTWH(x, y, w, d), fillPaint);
      //draw the boxes

      if (highlightedPackageId != null && pkg["countId"] == highlightedPackageId) {
        final highlightPaint = Paint()
          ..color = Colors.black
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;



        canvas.drawRect(Rect.fromLTWH(x, y, w, d), highlightPaint);
        //highlights the package
      }

      final textPainter = TextPainter(
        text: TextSpan(
          text: '${pkg["countId"]}',
          style: TextStyle(
              fontWeight:FontWeight.bold,color: Colors.black, fontSize: 20),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: w);

      textPainter.paint(
        canvas,
        Offset(x + (w - textPainter.width) / 2, y + (d - textPainter.height) / 2),
        //write the paackage id
      );
    }
  }

  @override
  bool shouldRepaint(covariant LorryPainter oldDelegate) {
    return oldDelegate.selectedLayer != selectedLayer ||
        oldDelegate.lorry != lorry ||
        oldDelegate.scale != scale;
  }
}
