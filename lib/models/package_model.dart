class Package {
  final int countId;
  final double height;
  final double length;
  final double surfaceArea;
  final String type;
  final double volume;
  final double weight;
  final double radius;
  final double width;
  int assignedLayer;

  Package({
    required this.countId,
    required this.height,
    required this.length,
    required this.surfaceArea,
    required this.type,
    required this.volume,
    required this.weight,
    required this.radius,
    required this.width,
    this.assignedLayer = 1,
  });


  factory Package.fromCSV(List<dynamic> csvRow,
      List<Package> allPackages ) {

    return Package(
      countId: int.tryParse(csvRow[0].toString()) ?? 0,
      height: double.tryParse(csvRow[1].toString()) ?? 0.0,
      length: double.tryParse(csvRow[2].toString()) ?? 0.0,
      surfaceArea: double.tryParse(csvRow[3].toString()) ?? 0.0,
      type: csvRow[4].toString(),
      volume: double.tryParse(csvRow[5].toString()) ?? 0.0,
      weight: double.tryParse(csvRow[6].toString()) ?? 0.0,
      radius: double.tryParse(csvRow[7].toString()) ?? 0.0,
      width: double.tryParse(csvRow[8].toString()) ?? 0.0,
      assignedLayer: determineLayer(
          double.tryParse(csvRow[1].toString()) ?? 0.0,
          double.tryParse(csvRow[6].toString()) ?? 0.0,
          allPackages
      ),
    );
  }

  static int determineLayer(double packageHeight, double packageWeight,
      List<Package> allPackages) {

    const double maxLorryHeight = 280.0;
    const double layerHeight = maxLorryHeight / 3;


    allPackages.sort((a, b) => b.weight.compareTo(a.weight));



    if (packageHeight > layerHeight * 2) {
      return 1;
    } else if (packageWeight >= 5.0) {
      return 1;
    } else if (packageHeight > layerHeight) {
      return 2;
    } else {
      return 3;
    }
  }
}
