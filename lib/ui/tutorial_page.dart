import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'welcome_screen.dart';
import 'uploader_screen.dart';

import 'package:url_launcher/url_launcher.dart';


class TutorialPage extends StatelessWidget {
  const TutorialPage({super.key});

  Future<void> _downloadTemplate() async {
    const url = 'https://raw.githubusercontent.com/jamesmb8/kerridgesystem/main/template/Templatecsv.csv';
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw '❌ Could not launch $url';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.pink],
          ),
        ),
        child: Stack(
          children: [
            // Logo
            Positioned(
              left: 10,
              child: Image.asset(
                "assets/images/logoKerridge.png",
                height: 125,
              ),
            ),
            // Back Button
            Positioned(
              right: 10,
              top: 20,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  backgroundColor: const Color(0xFF189281),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  "Back",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Content
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "TUTORIAL",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "How to Use Our System:",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.pink,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "You need to have a CSV file that contains the packages you would like to load. The title for these fields must be:",
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("• Count_ID", style: TextStyle(fontSize: 16)),
                              Text("• Height ()", style: TextStyle(fontSize: 16)),
                              Text("• Length ()", style: TextStyle(fontSize: 16)),
                              Text("• Surface-Area ()", style: TextStyle(fontSize: 16)),
                              Text("• Type", style: TextStyle(fontSize: 16)),
                              Text("• Volume ()", style: TextStyle(fontSize: 16)),
                              Text("• Weight ()", style: TextStyle(fontSize: 16)),
                              Text("• Radius ()", style: TextStyle(fontSize: 16)),
                              Text("• Width ()", style: TextStyle(fontSize: 16)),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "How to Understand the System:",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.pink,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "• The system will process your CSV file and use the ID to show you exactly where to place each package inside the lorry.",
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "• You can view 5 layers of the lorry and see where each package is located.",
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "• You can press the drop-down button to view the next lorry if multiple are needed.",
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "• You can download a PDF file that contains the lorry visualization and all loaded packages. This document will assist in physically loading the lorry.",
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: ElevatedButton.icon(
                              onPressed: _downloadTemplate,
                              icon: const Icon(Icons.download),
                              label: const Text("Download CSV Template"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pink.shade300,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            )

                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Thank you for using our system!",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.pink,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
