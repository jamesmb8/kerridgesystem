import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../models/package_model.dart';
import '../models/lorry_model.dart';
import 'uploader_screen.dart';
import '../data/file_loader.dart';


import 'package:flutter/material.dart';
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

    final borderPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawRect(Rect.fromLTWH(lorryX, lorryY, lorryLength, lorryWidth), borderPaint);

    final layerColors = [Colors.yellow, Colors.green, Colors.blue, Colors.red, Colors.purple];

    for (final pkg in lorry.packagePositions) {
      if (pkg["layer"] != selectedLayer) continue;

      final color = layerColors[(pkg["layer"] - 1) % layerColors.length];
      final fillPaint = Paint()..color = color;

      final x = lorryX + pkg["x"] * scale;
      final y = lorryY + pkg["y"] * scale;
      final w = pkg["width"] * scale;
      final d = pkg["depth"] * scale;

      canvas.drawRect(Rect.fromLTWH(x, y, w, d), fillPaint);

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
