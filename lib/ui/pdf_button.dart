import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../models/lorry_model.dart';
import '../data/pdf_generator.dart';

class PDFButton extends StatelessWidget {
  final Map<int, List<GlobalKey>> layerKeysMap;
  final List<Lorry> lorryList;
  final bool iconOnly;
  final Color? color;

  const PDFButton({
    Key? key,
    required this.layerKeysMap,
    required this.lorryList,
    this.iconOnly = false,
    this.color,
  }) : super(key: key);

  Future<void> _captureAndExport(BuildContext context) async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));
      await WidgetsBinding.instance.endOfFrame;

      final captures = <Map<String, dynamic>>[];

      for (final lorry in lorryList) {
        final keys = layerKeysMap[lorry.ID];
        if (keys == null || keys.length < 5) continue;

        for (int i = 0; i < 5; i++) {
          final key = keys[i];
          final boundary = key.currentContext?.findRenderObject();
          if (boundary is! RenderRepaintBoundary || boundary.size.isEmpty) continue;

          final image = await boundary.toImage(pixelRatio: 3.0);
          final byteData = await image.toByteData(format: ImageByteFormat.png);
          if (byteData == null) continue;

          captures.add({
            "lorryId": lorry.ID,
            "layer": i + 1,
            "bytes": byteData.buffer.asUint8List(),
          });
        }
      }

      await generateAndDownloadPdf(lorryList);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("PDF export failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return iconOnly
        ? IconButton(
      icon: Icon(Icons.download, color: color ?? Colors.pinkAccent),
      onPressed: () => _captureAndExport(context),
    )
        : ElevatedButton(
      onPressed: () => _captureAndExport(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Colors.pinkAccent,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      child: const Text("Download PDF"),
    );
  }
}
