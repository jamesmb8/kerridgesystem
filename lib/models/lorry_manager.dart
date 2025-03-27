import 'lorry_model.dart';
import 'package_model.dart';

class LorryManager {
  final List<Lorry> lorries = [];

  LorryManager(List<Package> packages) {
    packages.sort((a, b) => b.volume.compareTo(a.volume));
    //sort packages by volume

    int lorryIdCounter = 1;
    //start lorry id counter

    for (final pkg in packages) {
      bool placed = false;
      //every package starts at false

      for (final lorry in lorries) {
        if (lorry.tryPlacePackage(pkg)) {
          placed = true;
          break;
        }
        //try placing the packages in current lorry
      }

      if (!placed) {
        final newLorry = Lorry(ID: lorryIdCounter++, packages: []);
        if (newLorry.tryPlacePackage(pkg)) {
          lorries.add(newLorry);
        }
        //make a new lorry if packages cant be placed
      }
    }
  }
}

