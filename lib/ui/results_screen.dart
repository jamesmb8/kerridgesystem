import 'package:flutter/material.dart';
import '../models/lorry_model.dart';
import '../models/package_model.dart';
import 'layer_buttons.dart';
import 'lorry_painter.dart';


class ResultsScreen extends StatefulWidget {
  final Lorry lorry;

  const ResultsScreen({Key? key, required this.lorry}) : super(key: key);

  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  int _selectedLayer = 1; // Default to the first layer
  double scale = 1.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    scale = calculateScaleBasedOnScreenDimensions(widget.lorry, screenWidth, screenHeight);

    debugPrint("Calling calculatePackagePositions with scale: $scale");
    widget.lorry.calculatePackagePositions(scale);

    debugPrint("Total packages: ${widget.lorry.packages.length}");
    debugPrint("Total package positions: ${widget.lorry.packagePositions.length}");
  }

  void _changeLayer(int layerIndex) {
    setState(() {
      _selectedLayer = layerIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lorry Results")),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.4,
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
            LayerButtons(
              selectedLayer: _selectedLayer,
              onLayerChanged: _changeLayer,
            ),
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
                      "Size: ${package.length} x ${package.width} x ${package.height}, Weight: ${package.weight}, Layer: ${package.assignedLayer}",
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  double calculateScaleBasedOnScreenDimensions(Lorry lorry, double screenWidth, double screenHeight) {
    double widthScale = screenWidth / lorry.length;
    double heightScale = screenHeight / lorry.width;
    double scale = widthScale < heightScale ? widthScale : heightScale;
    scale = scale.clamp(0.1, 1.0);

    debugPrint("Calculated Scale: $scale");
    return scale;
  }
}
