import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:farm_buddy/pages/CropModel.dart';
import 'package:farm_buddy/pages/CropProvider.dart';
import 'package:farm_buddy/pages/LocalStorageService.dart';

class HomePage extends StatelessWidget {
  void _logout(BuildContext context) async {
    final localStorageService = LocalStorageService();
    await localStorageService.clearUserCredentials();
    Navigator.pushReplacementNamed(context, '/signin');
  }

  @override
  Widget build(BuildContext context) {
    final cropProvider = Provider.of<CropProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Farm Buddy'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CropSearch(cropProvider.crops),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Add Crop',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    _addCrop(context, cropProvider);
                  },
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  DateTime plantingDate = DateTime.now();
                  DateTime estimatedHarvestDate = plantingDate.add(Duration(days: 90));

                  cropProvider.addCrop(Crop(
                    name: value,
                    plantingDate: plantingDate,
                    estimatedHarvestDate: estimatedHarvestDate,
                  ));

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$value added to crops')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Crop name cannot be empty')),
                  );
                }
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cropProvider.crops.length,
              itemBuilder: (context, index) {
                final crop = cropProvider.crops[index];
                return ListTile(
                  title: Text(crop.name),
                  subtitle: Text(
                    'Planted on: ${crop.plantingDate}, Estimated Harvest: ${crop.estimatedHarvestDate}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _showEditDialog(context, cropProvider, crop);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _showDeleteDialog(context, cropProvider, crop);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Method to add a crop
  void _addCrop(BuildContext context, CropProvider cropProvider) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Crop'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: 'Crop Name'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final cropName = controller.text.trim();
                if (cropName.isNotEmpty) {
                  DateTime plantingDate = DateTime.now();
                  DateTime estimatedHarvestDate = plantingDate.add(Duration(days: 90));

                  cropProvider.addCrop(Crop(
                    name: cropName,
                    plantingDate: plantingDate,
                    estimatedHarvestDate: estimatedHarvestDate,
                  ));

                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$cropName added to crops')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Crop name cannot be empty')),
                  );
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, CropProvider cropProvider, Crop crop) {
    final TextEditingController controller = TextEditingController(text: crop.name);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Crop'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: 'Crop Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  cropProvider.updateCrop(crop.copyWith(name: controller.text));
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Crop name cannot be empty')),
                  );
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, CropProvider cropProvider, Crop crop) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Crop'),
          content: Text('Are you sure you want to delete ${crop.name}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                cropProvider.removeCrop(crop);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

class CropSearch extends SearchDelegate<Crop?> {
  final List<Crop> crops;

  CropSearch(this.crops);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () => query = '')];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = crops.where((crop) => crop.name.contains(query)).toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index].name),
          onTap: () {
            close(context, results[index]);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = crops.where((crop) => crop.name.contains(query)).toList();
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index].name),
          onTap: () {
            query = suggestions[index].name;
            showResults(context);
          },
        );
      },
    );
  }
}
