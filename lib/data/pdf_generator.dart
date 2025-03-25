import 'dart:typed_data';
import 'dart:html' as html;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/lorry_model.dart';

Future<void> generateAndDownloadPdfFromLorries(List<Lorry> lorries) async {
  final pdf = pw.Document();

  const double canvasWidth = 400; // arbitrary scale
  const double canvasHeight = 100; // adjust as needed

  for (final lorry in lorries) {
    lorry.calculatePackagePositions(1.0); // Scale 1.0 for simplicity

    pdf.addPage(
      pw.MultiPage(
        build: (context) {
          return [
            pw.Text("Lorry ${lorry.ID}",
                style: pw.TextStyle(
                    fontSize: 24, fontWeight: pw.FontWeight.bold)),
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

  final bytes = await pdf.save();
  final blob = html.Blob([bytes], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.window.open(url, "_blank");
}