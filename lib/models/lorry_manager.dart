import 'lorry_model.dart';
import 'package_model.dart';

class LorryManager {
  final List<Lorry> lorries = [];
  final double maxWeight = 10000;

  LorryManager(List<Package> packages) {
    packages.sort((a, b) => b.weight.compareTo(a.weight));

    int lorryId = 1;
    Lorry currentLorry = Lorry(ID: lorryId, packages: []);
    double currentWeight = 0;

    for (var pkg in packages) {
      if (currentWeight + pkg.weight <= maxWeight) {
        currentLorry.packages.add(pkg);
        currentWeight += pkg.weight;
      } else {
        lorries.add(currentLorry);
        lorryId++;
        currentLorry = Lorry(ID: lorryId, packages: [pkg]);
        currentWeight = pkg.weight;
      }
    }
    lorries.add(currentLorry); // Add last lorry
  }
}
