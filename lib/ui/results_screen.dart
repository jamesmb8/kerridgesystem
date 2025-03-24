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
  int _selectedLayer = 1;
  int? _selectedLorrie;// Default to the first layer

  List<int> Lorries = [1, 2, 3, 4, 5];

  void _changeLayer(int layerIndex) {
    setState(() {
      _selectedLayer = layerIndex;
    });
  }

    void _changeLorry(int? newLorry) {
      setState(() {
        _selectedLorrie = newLorry;
      });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scale = calculateScaleBasedOnScreenDimensions(widget.lorry, screenWidth, screenHeight);

    widget.lorry.calculatePackagePositions(scale);

    return Scaffold(
      appBar: AppBar(title: Text("Lorry Results"),
      backgroundColor:  Colors.white,
    ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.pink.shade200],
        ),
      ),

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

          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: DropdownButton(
            value: _selectedLorrie,
            hint: Text("Select a Lorrie", style: TextStyle(color: Colors.pink.shade300)),
            items: Lorries.map((int lorry) {
              return DropdownMenuItem<int>(
                value: lorry,
                child: Text("Lorry $lorry"),
              );
            }).toList(),
            onChanged: _changeLorry,
            isExpanded: true,
            elevation: 16,
            style: TextStyle(color: Colors.black),
            underline: Container(
              height: 2,
              color: Colors.blueAccent,
            ),
          ),
          ),

        Padding(padding: const EdgeInsets.all(16.0),
          child: Text(
              "Packages in Lorry",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.pink.shade300,
            ),

          ),

        ),


          // Package list below the lorry visualization

          Expanded(
            flex: 2,
            child: widget.lorry.packages.isEmpty
                ? Center(child: Text("No packages loaded", style: TextStyle(color: Colors.red)))
                : ListView.builder(
              itemCount: widget.lorry.packages.length,
              itemBuilder: (context, index) {
                Package package = widget.lorry.packages[index];
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                    child:  ListTile(
                title: Text("Package ${package.countId}: ${package.type}"),
                subtitle: Text(
                "Size: ${package.length} x ${package.width} x ${package.height}, Weight: ${package.weight}",
                ),
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