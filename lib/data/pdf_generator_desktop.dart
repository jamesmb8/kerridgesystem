import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/lorry_model.dart';

Future<void> generateAndDownloadPdfFromLorries(List<Lorry> lorries, double scale) async {
  final pdf = pw.Document();

  const double canvasWidth = 565;
  const double canvasHeight = 113;

  for (final lorry in lorries) {
    lorry.calculatePackagePositions(1.0);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (context) {
          return [
            pw.Text("Lorry ${lorry.ID}",
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),

            for (int layer = 1; layer <= 5; layer++) ...[
              pw.Text("Layer $layer", style: const pw.TextStyle(fontSize: 18)),
              pw.Container(
                width: canvasWidth,
                height: canvasHeight,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(width: 1),
                ),
                child: pw.Stack(
                  children: [
                    for (final pkg in lorry.packagePositions)
                      if (pkg["layer"] == layer)
                        pw.Positioned(
                          left: pkg["x"] * 0.4,
                          top: pkg["y"] * 0.4,
                          child: pw.SizedBox(
                            width: pkg["width"] * 0.4,
                            height: pkg["depth"] * 0.4,
                            child: pw.Container(
                              decoration: pw.BoxDecoration(
                                color: PdfColors.pink100,
                                border: pw.Border.all(width: 0.5),
                              ),
                              alignment: pw.Alignment.center,
                              child: pw.Text(pkg["countId"].toString(),
                                  style: const pw.TextStyle(fontSize: 6)),
                            ),
                          ),
                        ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
            ],
          ];
        },
      ),
    );
  }

  final output = await getApplicationDocumentsDirectory();
  final file = File("${output.path}/lorry_output.pdf");
  await file.writeAsBytes(await pdf.save());
  print("✅ PDF saved to: ${file.path}");

  try {
    if (Platform.isMacOS) {
      await Process.run('open', [file.path]);
    } else if (Platform.isWindows) {
      await Process.run('start', [file.path], runInShell: true);
    }
  } catch (e) {
    print("❌ Failed to open PDF automatically: $e");
  }
}
