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
  });

  // Factory constructor to create a Package from CSV row
  factory Package.fromCSV(List<dynamic> csvRow, int id) {
    return Package(
      countId: int.tryParse(csvRow[0].toString()) ?? 0,
      height: double.tryParse(csvRow[1].toString()) ?? 0.0,
      length: double.tryParse(csvRow[2].toString()) ?? 0.0,
      surfaceArea: double.tryParse(csvRow[3].toString()) ?? 0.0,
      type: csvRow[4].toString(),
      volume: double.tryParse(csvRow[5].toString()) ?? 0.0,
      weight: double.tryParse(csvRow[6].toString()) ?? 0.0,
      radius: double.tryParse(csvRow[7].toString()) ?? 0.0,
      width: double.tryParse(csvRow[8].toString()) ?? 0.0, // Assuming column 8 is for width
    );
  }
}
