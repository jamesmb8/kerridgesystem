import 'package:flutter/material.dart';
import '../models/lorry_model.dart';
import '../models/package_model.dart';
import 'layer_buttons.dart';
import 'lorry_painter.dart';
import '../models/lorry_manager.dart';




class ResultsScreen extends StatefulWidget {
  final List<Lorry> lorries;

  const ResultsScreen({Key? key, required this.lorries}) : super(key: key);

  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  int _selectedLayer = 1;
  int _selectedLorryIndex = 0;
  double scale = 1.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _recalculateLayout();
  }

  void _recalculateLayout() {
    final lorry = widget.lorries[_selectedLorryIndex];
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    scale = calculateScaleBasedOnScreenDimensions(lorry, screenWidth, screenHeight);
    lorry.calculatePackagePositions(scale);
  }

  void _changeLayer(int layerIndex) {
    setState(() {
      _selectedLayer = layerIndex;
    });
  }

  void _changeLorry(int? index) {
    if (index == null) return;
    setState(() {
      _selectedLorryIndex = index;
      _selectedLayer = 1;
      _recalculateLayout();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentLorry = widget.lorries[_selectedLorryIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lorry Results"),
        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.pink.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
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
                      lorry: currentLorry,
                      scale: scale,
                      selectedLayer: _selectedLayer,
                    ),
                  ),
                ),
              ),
            ),
            const Divider(),
            const SizedBox(height: 10),

            LayerButtons(
              selectedLayer: _selectedLayer,
              onLayerChanged: _changeLayer,
            ),

            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: DropdownButton<int>(
                value: _selectedLorryIndex,
                hint: Text("Select a Lorry", style: TextStyle(color: Colors.pink.shade300)),
                items: List.generate(widget.lorries.length, (index) {
                  return DropdownMenuItem<int>(
                    value: index,
                    child: Text("Lorry ${widget.lorries[index].ID}"),
                  );
                }),
                onChanged: _changeLorry,
                isExpanded: true,
                elevation: 16,
                style: const TextStyle(color: Colors.black),
                underline: Container(height: 2, color: Colors.blueAccent),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Packages in Lorry ${currentLorry.ID}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink.shade300,
                ),
              ),
            ),

            Expanded(
              flex: 2,
              child: currentLorry.packages.isEmpty
                  ? const Center(child: Text("No packages loaded", style: TextStyle(color: Colors.red)))
                  : ListView.builder(
                itemCount: currentLorry.packages.length,
                itemBuilder: (context, index) {
                  final package = currentLorry.packages[index];
                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text("Package ${package.countId}: ${package.type}"),
                      subtitle: Text(
                        "Size: ${package.length} x ${package.width} x ${package.height}, "
                            "Weight: ${package.weight}, Layer: ${package.assignedLayer}",
                      ),
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
    double widthScale = screenWidth / (lorry.length * 100);
    double heightScale = screenHeight / (lorry.width * 100);
    return (widthScale < heightScale ? widthScale : heightScale).clamp(0.1, 1.0);
  }
}
