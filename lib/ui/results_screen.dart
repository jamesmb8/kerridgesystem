import 'package:flutter/material.dart';
import '../models/lorry_model.dart';
import '../models/package_model.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import 'lorry_painter.dart';
import 'layer_buttons.dart';

class ResultsScreen extends StatefulWidget {
  final Lorry lorry;

  const ResultsScreen({Key? key, required this.lorry}) : super(key: key);

  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  int _selectedLayer = 1; // Default to the first layer

  void _changeLayer(int layerIndex) {
    setState(() {
      _selectedLayer = layerIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scale = calculateScaleBasedOnScreenDimensions(widget.lorry, screenWidth, screenHeight);

    widget.lorry.calculatePackagePositions(scale);

    return Scaffold(
      appBar: AppBar(title: Text("Lorry Results")),
      body: Container(
        color: Colors.white,
        child: Column(



        children: [
          // Lorry visualization
          Expanded(
            flex: 3,
            child: Center(
              child: Container(
                width: screenWidth,
                height: screenHeight * 0.4, // Adjust height for lorry visualization
                child: CustomPaint(
                  painter: LorryPainter(
                      lorry: widget.lorry,
                      scale: scale,
                    selectedLayer: _selectedLayer,

                  ),
                ),
              ),
            ),
          ),
          const Divider(),
          const SizedBox(height: 15),

          LayerButtons(selectedLayer: _selectedLayer,

            onLayerChanged: _changeLayer,
          ),
          SizedBox(height: 15),




          // Package list below the lorry visualization
          Text("Packages in Lorry", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Expanded(
            flex: 2,
            child: widget.lorry.packages.isEmpty
                ? Center(child: Text("No packages loaded", style: TextStyle(color: Colors.red)))
                : ListView.builder(
              itemCount: widget.lorry.packages.length,
              itemBuilder: (context, index) {
                Package package = widget.lorry.packages[index];
                return ListTile(
                  title: Text("Package ${package.countId}: ${package.type}"),
                  subtitle: Text(
                    "Size: ${package.length} x ${package.width} x ${package.height}, Weight: ${package.weight}",
                  ),
                );
              },
            ),
          ),
          // Layer selection buttons



        ],
      ),
      ),
    );
  }

  double calculateScaleBasedOnScreenDimensions(Lorry lorry, double screenWidth, double screenHeight) {
    // Scaling based on lorry size and screen dimensions
    double widthScale = screenWidth / lorry.length;
    double heightScale = screenHeight / lorry.width;

    // Choose the smaller scale factor to ensure the lorry fits on screen
    double scale = widthScale < heightScale ? widthScale : heightScale;

    // Clamp the scale to prevent excessive scaling
    scale = scale.clamp(0.1, 1.0);  // Adjust the maximum scale factor

    debugPrint("Calculated Scale: $scale");
    return scale;  // Return the adjusted scale factor
  }
}