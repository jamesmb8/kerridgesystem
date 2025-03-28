import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

Future<void> downloadCSVTemplate(BuildContext context) async {
  final bytes = await rootBundle.load('assets/templates/Templatecsv.csv');
  final data = bytes.buffer.asUint8List();

  final dir = await getDownloadsDirectory();
  final file = File('${dir!.path}/Templatecsv.csv');
  await file.writeAsBytes(data);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('✅ Template saved to: ${file.path}')),
  );

  // Optional: Open Downloads folder
  if (Platform.isMacOS) {
    await Process.run('open', [dir.path]);
  } else if (Platform.isWindows) {
    await Process.run('explorer', [dir.path]);
  }
}
