import 'package:flutter/material.dart';
import '../models/lorry_model.dart';
import '../data/pdf_generator_wrapper.dart';




class PDFButton extends StatelessWidget {
  final List<Lorry> lorries;
  final bool iconOnly;
  final Color? color;
  final double scale;

  const PDFButton({
    Key? key,
    required this.lorries,
    required this.scale,
    this.iconOnly = false,
    this.color,
  }) : super(key: key);

  Future<void> _generate(BuildContext context) async {
    try {
      await generateAndDownloadPdfFromLorries(lorries, scale);
    } catch (e) {
      print("❌ PDF error: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("PDF error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return iconOnly
        ? IconButton(
      icon: Icon(Icons.download, color: color ?? Colors.pinkAccent),
      //creating the pdf button
      onPressed: () => _generate(context),
    )
        : ElevatedButton(
      onPressed: () => _generate(context),
      child: const Text("Download PDF"),
    );
  }
}
