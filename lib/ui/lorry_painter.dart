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


  LorryPainter({required this.lorry, required this.scale, required this.selectedLayer, this.highlightedPackageId});

  @override
  void paint(Canvas canvas, Size size) {
    double lorryWidth = lorry.width * 100 * scale;
    double lorryLength = lorry.length * 100 * scale;
    double lorryX = (size.width - lorryLength) / 2;
    double lorryY = (size.height - lorryWidth) / 2;

    final borderPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawRect(Rect.fromLTWH(lorryX, lorryY, lorryLength, lorryWidth), borderPaint);

    final layerColors = [Colors.yellow, Colors.green, Colors.blue, Colors.red, Colors.purple];
    const double layerHeight = Lorry.maxLorryHeight / 5;

    for (final pkg in lorry.packagePositions) {
      final startLayer = pkg["layer"];
      final layerSpan = (pkg["height"] / layerHeight).ceil();

      if (selectedLayer < startLayer || selectedLayer >= startLayer + layerSpan) continue;

      final color = layerColors[(startLayer - 1) % layerColors.length];
      final fillPaint = Paint()..color = color;

      final x = lorryX + pkg["x"] * scale;
      final y = lorryY + pkg["y"] * scale;
      final w = pkg["width"] * scale;
      final d = pkg["depth"] * scale;

      canvas.drawRect(Rect.fromLTWH(x, y, w, d), fillPaint);
      if (highlightedPackageId != null && pkg["countId"] == highlightedPackageId) {
        final highlightPaint = Paint()
          ..color = Colors.black
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke;

        canvas.drawRect(Rect.fromLTWH(x, y, w, d), highlightPaint);
      }

      final textPainter = TextPainter(
        text: TextSpan(
          text: '${pkg["countId"]}',
          style: TextStyle(color: Colors.black, fontSize: 12),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: w);

      textPainter.paint(
        canvas,
        Offset(x + (w - textPainter.width) / 2, y + (d - textPainter.height) / 2),
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
