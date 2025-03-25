import 'dart:typed_data';
import 'dart:html' as html;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/lorry_model.dart';

Future<void> generateAndDownloadPdf(List<Lorry> lorries) async {
  final pdf = pw.Document();

  for (var lorry in lorries) {
    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) {
          return [
            pw.Text("Lorry ${lorry.ID}", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            for (var pkg in lorry.packages)
              pw.Bullet(
                text:
                "Package ${pkg.countId} (${pkg.type}) - ${pkg.length}x${pkg.width}x${pkg.height}, "
                    "Weight: ${pkg.weight}, Layer: ${pkg.assignedLayer}",
              ),
          ];
        },
      ),
    );
  }

  final Uint8List bytes = await pdf.save();
  final blob = html.Blob([bytes], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.window.open(url, "_blank");
}
