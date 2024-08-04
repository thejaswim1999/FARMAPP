import 'package:flutter/foundation.dart';
import 'package:farm_buddy/pages/CropModel.dart';

class CropProvider extends ChangeNotifier {
  List<Crop> _crops = [];
  List<Crop> _harvestedCrops = [];
  
  List<Crop> get crops => _crops;
  List<Crop> get harvestedCrops => _harvestedCrops;

  void addCrop(Crop crop) {
    _crops.add(crop);
    notifyListeners();
  }

  void markAsHarvested(Crop crop) {
    crop.isHarvested = true;
    crop.actualHarvestDate = DateTime.now();
    _harvestedCrops.add(crop);
    _crops.remove(crop);
    notifyListeners();
  }

  void removeCrop(Crop crop) {
    _crops.remove(crop);
    notifyListeners();
  }
  void updateCrop(Crop updatedCrop) {
    final index = _crops.indexWhere((crop) => crop.name == updatedCrop.name);
    if (index != -1) {
      _crops[index] = updatedCrop;
      notifyListeners();
    }
  }
}
