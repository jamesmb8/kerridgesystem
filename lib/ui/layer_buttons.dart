import 'package:flutter/material.dart';
import '../models/lorry_model.dart';
import '../models/package_model.dart';

class LayerButtonScreen extends StatefulWidget {
  const LayerButtonScreen({super.key});

  @override
  _LayerButtonScreenState createState() => _LayerButtonScreenState();
}

class _LayerButtonScreenState extends State<LayerButtonScreen> {
  int _selectedLayer = 1;

  // Assuming you have a lorry instance to get package positions by layer
  Lorry lorry = Lorry(
    ID: 1,
    length: 14.0,
    width: 2.8,
    doorheight: 2.8,
    maxweight: 10000,
    packages: [/* Your packages here */],
  );

  // Function to change the selected layer
  void _changeLayer(int layerIndex) {
    setState(() {
      _selectedLayer = layerIndex;
    });
  }

  // Function to display the content for the selected layer
  Widget _getLayerContent() {
    // Ensure the selected layer is within the range
    if (_selectedLayer - 1 < lorry.packagePositionsByLayer.length) {
      List<Offset> currentLayer = lorry.packagePositionsByLayer[_selectedLayer - 1];
      return CustomPaint(
        size: Size(double.infinity, 200), // Set size of the canvas
        painter: PackagePainter(currentLayer),
      );
    } else {
      return const Center(child: Text("No packages in this layer"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Display the current layer's packages
        _getLayerContent(),

        const SizedBox(height: 20),

        // Layer buttons to select layers
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Layer 1 Button
            ElevatedButton(
              onPressed: () => _changeLayer(1),
              child: const Text('Layer 1'),
            ),
            const SizedBox(width: 10),
            // Layer 2 Button
            ElevatedButton(
              onPressed: () => _changeLayer(2),
              child: const Text('Layer 2'),
            ),
            const SizedBox(width: 10),
            // Layer 3 Button
            ElevatedButton(
              onPressed: () => _changeLayer(3),
              child: const Text('Layer 3'),
            ),
          ],
        ),
      ],
    );
  }
}

class PackagePainter extends CustomPainter {
  final List<Offset> packagePositions;

  PackagePainter(this.packagePositions);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    for (var position in packagePositions) {
      canvas.drawRect(Rect.fromLTWH(position.dx, position.dy, 100, 100), paint); // Draw each package as a square
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
