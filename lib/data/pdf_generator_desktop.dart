import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/lorry_model.dart';

Future<void> generateAndDownloadPdfFromLorries(List<Lorry> lorries, double scale) async {
  final pdf = pw.Document();
  //creates a new pdf and sets the size for the pdf

  const double canvasWidth = 565;
  const double canvasHeight = 113;

  for (final lorry in lorries) {
    //loops through each lorry


    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (context) {
          return [
            pw.Text("Lorry ${lorry.ID}",
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            //adds a lorry ID header for each lorry

            for (int layer = 1; layer <= 5; layer++) ...[
              pw.Text("Layer $layer", style: const pw.TextStyle(fontSize: 18)),
              pw.Container(
                width: canvasWidth,
                height: canvasHeight,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(width: 1),
                ),
                //loops through each header
                child: pw.Stack(
                  children: [
                    for (final pkg in lorry.packagePositions)
                      if (pkg["layer"] == layer)
                        pw.Positioned(
                          left: pkg["x"] * 0.4,
                          top: pkg["y"] * 0.4,
                          //loops through each package
                          child: pw.SizedBox(
                            width: pkg["width"] * 0.4,
                            height: pkg["depth"] * 0.4,
                            //scale the package properly
                            child: pw.Container(
                              decoration: pw.BoxDecoration(
                                color: PdfColors.pink100,
                                border: pw.Border.all(width: 0.5),
                              ),
                              alignment: pw.Alignment.center,
                              child: pw.Text(pkg["countId"].toString(),
                                  style: const pw.TextStyle(fontSize: 6)),
                              //write the packageID
                            ),
                          ),
                        ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              ],

              // Checklist Section
              pw.Text("Package Checklist", style: const pw.TextStyle(fontSize: 18)),
              pw.SizedBox(height: 5),
            //Header for the checklist
              pw.Wrap(
                spacing: 10,
                runSpacing: 4,
                children: [
                  for (final pkg in lorry.packages)
                    pw.Row(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.Container(
                          width: 10,
                          height: 10,
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(width: 0.5),
                          ),
                        ),
                        pw.SizedBox(width: 5),
                        //checkbox width
                        pw.Text(
                          'Package ${pkg.countId} '
                              '(${pkg.length}×${pkg.width}×${pkg.height} cm, '
                              '${pkg.weight} kg)',
                          style: const pw.TextStyle(fontSize: 8),
                          //showing the packages alongside the checkbox
                        ),
                      ],
                    )
                ],
              ),


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
