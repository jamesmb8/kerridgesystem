import 'package:flutter/material.dart';

class LayerButtons extends StatelessWidget {
  final int selectedLayer;
  final Function(int) onLayerChanged;

  const LayerButtons({
    super.key,
    required this.selectedLayer,
    required this.onLayerChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        int layerNumber = index + 1;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: ElevatedButton(
            onPressed: () => onLayerChanged(layerNumber),
            style: ElevatedButton.styleFrom(
              backgroundColor: selectedLayer == layerNumber ? Colors.blue : Colors.grey,
            ),
            child: Text('Layer $layerNumber'),
          ),
        );
      }),
    );
  }
}