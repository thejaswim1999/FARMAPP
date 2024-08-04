import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:farm_buddy/pages/CropProvider.dart';

class HarvestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cropProvider = Provider.of<CropProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Harvested Crops')),
      body: ListView.builder(
        itemCount: cropProvider.harvestedCrops.length,
        itemBuilder: (context, index) {
          final crop = cropProvider.harvestedCrops[index];
          return ListTile(
            title: Text(crop.name),
            subtitle: Text(
                'Expected: ${crop.estimatedHarvestDate}, Actual: ${crop.actualHarvestDate}'),
          );
        },
      ),
    );
  }
}
